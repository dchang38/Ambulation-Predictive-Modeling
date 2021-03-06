import csv
import io
import Patient

# Create patient objects from historical_details.csv file and store in array
def generatePatients(filename):
	inputFile = io.open(filename, "r", encoding='utf-8-sig')
	reader = csv.DictReader(inputFile)
	patients = []
	ambulations = []
	id = 1
	for row in reader:
		if id == int(row["patient_ID"]):
			maxHour = int(row["max_hour"])
			ambulations.append({"ambulation": int(row["ambulation"]), "date": row["date"], "timeOfDay": row["time_of_day"], "transferDate": row["Transfer Date"], "dayOnUnit": int(row["Day on Unit"]), "distance": float(row["distance"]), "duration": float(row["duration"]), "speed": float(row["speed"]), "hourOfDay": int(row["hour_of_day"]), "hoursOfStay": int(row["hours_of_stay"])})
		else:
			maxHour = int(row["max_hour"])
			p = Patient.Patient(id, ambulations, maxHour)
			patients.append(p)
			ambulations = []
			id = int(row["patient_ID"])
			ambulations.append({"ambulation": int(row["ambulation"]), "date": row["date"], "timeOfDay": row["time_of_day"], "transferDate": row["Transfer Date"], "dayOnUnit": int(row["Day on Unit"]), "distance": float(row["distance"]), "duration": float(row["duration"]), "speed": float(row["speed"]), "hourOfDay": int(row["hour_of_day"]), "hoursOfStay": int(row["hours_of_stay"])})

	return patients

def incrementDate(dateString):
	day = 0
	right = dateString[-5:]
	date = dateString[:-5]
	left = date[:2]
	date = date[2:]
	try:
		day = int(date)
	except:
		left += date[:1]
		date = date[1:]
		day = int(date)
	day += 1
	date = left + str(day) + right
	return date

def checkHour(hour, ambulations):
	for ambulation in ambulations:
		if hour == ambulation["hoursOfStay"]:	
			return True
	return False


# write patient id data to output file
def writePatientsCsv(patients):
	filename = "Patients_hourly_data.csv"
	file = open(filename, 'w', newline = '')
	with file:
		fields = ["Patient ID", "Day On Unit", "Hour Of Stay", "Date", "Ambulations", "Daily Ambulation Total", "Hour", "Walking", "Number Of Times", "Distance", "Duration", "Average Speed", "Hours Since Last Walk", "Distance Of Last Walk", "Total Distance Walked"]
		writer = csv.DictWriter(file, fieldnames=fields)
		writer.writeheader()
		for patient in patients:
			id = patient.id
			date = patient.ambulations[0]["transferDate"]
			dayNum = 0
			dailyAmb = 0
			amb = 0
			hasWalked = False
			hoursSinceLastWalk = 0
			totalDistance = 0
			distance = 0
			for hour in range(patient.maxHour + 1):
				day = int(hour / 24)
				if day != dayNum: # reset number of daily ambulations
					dailyAmb = 0
					dayNum = day
				if checkHour(hour, patient.ambulations) == True: # patient walked during this hour
					hasWalked = True
					hoursSinceLastWalk = 0
					numTimes = 0
					amb = 0
					avgSpeed = 0.0
					ambulationDate = ""
					hourOfDay = 0
					duration = 0.0
					for ambulation in patient.ambulations: # find every patient ambulation in this hour
						if hour == ambulation["hoursOfStay"]:
							hourOfDay = ambulation["hourOfDay"]
							ambulationDate = ambulation["date"]
							numTimes += 1
							amb += int(ambulation["ambulation"])
							dailyAmb += 1
							distance = ambulation["distance"]
							totalDistance += distance
							duration += ambulation["duration"]
							avgSpeed = distance / duration
					writer.writerow({'Patient ID': id, 'Day On Unit': day, 'Hour Of Stay': hour, 'Date': ambulationDate, 'Ambulations': amb, 'Daily Ambulation Total': dailyAmb,'Hour': hourOfDay, 'Walking': 1, 'Number Of Times': numTimes, 'Distance': distance, 'Duration': duration, 'Average Speed': avgSpeed, 'Hours Since Last Walk': hoursSinceLastWalk, 'Distance Of Last Walk': distance, 'Total Distance Walked': totalDistance})
				else: # patient didn't walk this hour
					if hasWalked == True: # increment time since last walk
						hoursSinceLastWalk += 1
					newDate = date
					for x in range(day):
						newDate = incrementDate(newDate)
					hourOfDay = hour % 24
					writer.writerow({'Patient ID': id, 'Day On Unit': day, 'Hour Of Stay': hour, 'Date': newDate, 'Ambulations': amb, 'Daily Ambulation Total': dailyAmb, 'Hour': hourOfDay, 'Walking': 0, 'Number Of Times': 0, 'Distance': 0, 'Duration': 0, 'Average Speed': 0, 'Hours Since Last Walk': hoursSinceLastWalk, 'Distance Of Last Walk': distance, 'Total Distance Walked': totalDistance})	
			
def writeCsv(days, numPatients, filename):
	filename = filename
	file = open(filename, 'w')
	with file:
		fields = ["Day", "Patients", "Percent"]
		writer = csv.DictWriter(file, fieldnames=fields)
		writer.writeheader()
		for x in range(15):
			writer.writerow({'Day' : x+1, 'Patients' : numPatients[x+1], 'Percent' : days[x+1]})

def getPercentOfPatients(patients, filename):
	days = {}
	numPatients = {}
	for x in range(15):
		days[x+1] = 0
		numPatients[x+1] = 0
	for patient in patients:
		for x in range(15):
			if x <= (patient.maxHour/24):
				numPatients[x+1] += 1
	for patient in patients:
		s = set()
		for ambulation in patient.ambulations:
			if not ambulation["dayOnUnit"] in s:
				days[ambulation["dayOnUnit"]] += 1
				s.add(ambulation["dayOnUnit"])
	for x in range(15):
		if(numPatients[x+1] != 0):
			days[x+1] = round((days[x+1] / numPatients[x+1]) * 100, 2)
		else:
			days[x+1] = -1
	writeCsv(days, numPatients, filename)

patients = generatePatients('data_files/historical_details.csv')
writePatientsCsv(patients)
#getPercentOfPatients(patients, "percent_of_patients_not_readmitted.csv")
