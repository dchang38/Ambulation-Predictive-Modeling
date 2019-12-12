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
	filename = "Patients_hourly_data_one_over_HSLW.csv"
	file = open(filename, 'w', newline = '')
	with file:
		fields = ["Patient ID", "Day On Unit", "Hour Of Stay", "Date", "Ambulations", "Daily Ambulation Total", "Hour Of Day", "Going to Walk", "Walking", "Number Of Times", "Distance", "Duration", "Average Speed", "1/Hours Since Last Walk", "Distance Of Last Walk", "Total Distance Walked"]
		writer = csv.DictWriter(file, fieldnames=fields)
		writer.writeheader()
		for patient in patients:
			id = patient.id
			hasWalked = False
			date = patient.ambulations[0]["transferDate"]
			dayNum = 0
			dailyAmb = 0
			amb = 0
			hoursSinceLastWalk = 0
			fractionHoursSinceLastWalk = 0
			totalDistance = 0
			for hour in range(patient.maxHour + 1):
				distance = 0
				numTimes = 0
				avgSpeed = 0.0
				duration = 0.0
				walking = 0
				ambulationDate = ''
				day = int(hour / 24)
				goingToWalk = 1
				if day != dayNum: # reset number of daily ambulations
					dailyAmb = 0
					dayNum = day
				if checkHour(hour, patient.ambulations) == True: # patient walked during this hour
					hasWalked = True
					hoursSinceLastWalk = 0
					fractionHoursSinceLastWalk = 10 # some large value
					numTimes = 0
					amb = 0
					hourOfDay = 0
					walking = 1
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
				else: # patient didn't walk this hour
					if checkHour(hour+1, patient.ambulations) == True:
						goingToWalk = 0
					if hasWalked == True:
						hoursSinceLastWalk += 1
					if hoursSinceLastWalk > 0:
						fractionHoursSinceLastWalk = 1 / hoursSinceLastWalk
					else:
						fractionHoursSinceLastWalk = 0
					newDate = date
					for x in range(day):
						newDate = incrementDate(newDate)
					hourOfDay = hour % 24
				writer.writerow({'Patient ID': id, 'Day On Unit': day, 'Hour Of Stay': hour, 'Date': newDate, 'Ambulations': amb, 'Daily Ambulation Total': dailyAmb, 'Hour Of Day': hourOfDay, 'Going to Walk': goingToWalk, 'Walking': walking, 'Number Of Times': numTimes, 'Distance': distance, 'Duration': duration, 'Average Speed': avgSpeed, '1/Hours Since Last Walk': fractionHoursSinceLastWalk, 'Distance Of Last Walk': distance, 'Total Distance Walked': totalDistance})	
						

patients = generatePatients('data_files/historical_details.csv')
writePatientsCsv(patients)
