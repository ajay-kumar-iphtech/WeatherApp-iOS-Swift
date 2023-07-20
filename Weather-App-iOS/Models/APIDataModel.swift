import Foundation

// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    let location: Location?
    let current: Current?
}

// MARK: - Current
struct Current: Codable {
    let lastUpdated: String?
    let tempC, isDay: Int?
    let condition: Condition?
    let windKph: Double?
    let pressureMB, humidity, cloud: Int?
    let visKM: Double
    let uv: Int?

    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case isDay = "is_day"
        case condition
        case windKph = "wind_kph"
        case pressureMB = "pressure_mb"
        case humidity, cloud
        case visKM = "vis_km"
        case uv
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text, icon: String?
}

// MARK: - Location
struct Location: Codable {
    let name, region, country: String?
    let lat, lon: Double?
    let tzID: String?
    let localtimeEpoch: Int?
    let localtime: String?

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}

struct ForcastWeather: Codable {
    let forecast: Forecast?
    let location: Location?
    let current: Current?
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]?
}

// MARK: - Forecastday
struct Forecastday: Codable {
    let date: String?
    let day: Day?
    let astro: Astro?
    let hour: [Hour]?
}

// MARK: - Astro
struct Astro: Codable {
    let sunrise, sunset, moonrise, moonset: String?
    let moonPhase: String?
    let isMoonUp, isSunUp: Int?

    enum CodingKeys: String, CodingKey {
        case sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case isMoonUp = "is_moon_up"
        case isSunUp = "is_sun_up"
    }
}

// MARK: - Day
struct Day: Codable {
    let maxtempC, mintempC, maxwindKph: Double?
    let totalsnowCM, avghumidity: Int?
    let avgvisKM: Double?
    let condition: Condition?
    let uv: Int?

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case maxwindKph = "maxwind_kph"
        case totalsnowCM = "totalsnow_cm"
        case avgvisKM = "avgvis_km"
        case avghumidity, condition, uv
    }
}

// MARK: - Hour
struct Hour: Codable {
    let time: String?
    let tempC: Double?
    let isDay: Int?
    let condition: Condition?
    let windKph: Double?
    let pressureMB, humidity, cloud: Int?
    let windchillF: Double?
    let visKM, uv: Int?

    enum CodingKeys: String, CodingKey {
        case time
        case tempC = "temp_c"
        case isDay = "is_day"
        case condition
        case windKph = "wind_kph"
        case pressureMB = "pressure_mb"
        case humidity, cloud
        case windchillF = "windchill_f"
        case visKM = "vis_km"
        case uv
    }
}
