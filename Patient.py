class Patient:
	def __init__(self, id, ambulations, maxHour):
		self.id = id
		self.ambulations = ambulations
		self.maxHour = maxHour

	def isWalking(self, date, hour):
		for ambulation in self.ambulations:
			if ambulation["date"] == date and ambulation["hourOfDay"] == hour:
				return True
		return False

	def getDailyAmbulations(self, date):
		counter = 0
		for ambulation in self.ambulations:
			if ambulation["date"] == date:
				counter += 1
		return counter

	def getAmbulations(self):
		total = 0
		for ambulation in self.ambulations:
			total = int(ambulation["ambulation"])
		return total

	def getAmbulationsAtDate(self, date):
		total = 0
		day = ambulations[0]["date"]
		for ambulation in self.ambulations:
			if day == date:
				break
			total = int(ambulation["ambulation"])
		return total