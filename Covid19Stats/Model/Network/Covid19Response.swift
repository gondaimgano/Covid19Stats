

import Foundation

// MARK: - CovidSummaryResponse
class CovidSummaryResponse: Codable {
    let id, message: String
    let global: Global
    let countries: [Country]
  //  let date: DateEnum

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case message = "Message"
        case global = "Global"
        case countries = "Countries"
      //  case date = "Date"
    }

    init(id: String, message: String, global: Global, countries: [Country]) {
        self.id = id
        self.message = message
        self.global = global
        self.countries = countries
     //   self.date = date
    }
}

// MARK: - Country
class Country: Codable {
    let id, country, countryCode, slug: String
    let newConfirmed, totalConfirmed, newDeaths, totalDeaths: Int
    let newRecovered, totalRecovered: Int
  //  let date: DateEnum
  //  let premium: Premium

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case country = "Country"
        case countryCode = "CountryCode"
        case slug = "Slug"
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
       // case date = "Date"
        //case premium = "Premium"
    }

    init(id: String, country: String, countryCode: String, slug: String, newConfirmed: Int, totalConfirmed: Int, newDeaths: Int, totalDeaths: Int, newRecovered: Int, totalRecovered: Int//date: DateEnum, premium: Premium
    ) {
        self.id = id
        self.country = country
        self.countryCode = countryCode
        self.slug = slug
        self.newConfirmed = newConfirmed
        self.totalConfirmed = totalConfirmed
        self.newDeaths = newDeaths
        self.totalDeaths = totalDeaths
        self.newRecovered = newRecovered
        self.totalRecovered = totalRecovered
      //  self.date = date
      //  self.premium = premium
    }
}

enum DateEnum: String, Codable {
    case the20210211T135008619Z = "2021-02-11T13:50:08.619Z"
}

// MARK: - Premium
class Premium: Codable {

    init() {
    }
}

// MARK: - Global
class Global: Codable {
    let newConfirmed, totalConfirmed, newDeaths, totalDeaths: Int
    let newRecovered, totalRecovered: Int
   // let date: DateEnum

    enum CodingKeys: String, CodingKey {
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
      //  case date = "Date"
    }

    init(newConfirmed: Int, totalConfirmed: Int, newDeaths: Int, totalDeaths: Int, newRecovered: Int, totalRecovered: Int// date: DateEnum
    ) {
        self.newConfirmed = newConfirmed
        self.totalConfirmed = totalConfirmed
        self.newDeaths = newDeaths
        self.totalDeaths = totalDeaths
        self.newRecovered = newRecovered
        self.totalRecovered = totalRecovered
       // self.date = date
    }
}
