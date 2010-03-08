class Time
	def self.random(years_back=5)
		year = Time.now.year - rand(years_back) - 1
		month = rand(12) + 1
		day = rand(31) + 1
		Time.local(year, month, day)
	end
	
	def self.random_range(years_back=5)
		year = Time.now.year - rand(years_back) - 1
		month = rand(12) + 1
		day = rand(31) + 1
		start_date = Time.local(year, month, day)
		year = year + rand(years_back) + 1
		month = rand(12) + 1
		day = rand(31) + 1
		end_date = Time.local(year, month, day)
		[start_date, end_date]
	end	
end