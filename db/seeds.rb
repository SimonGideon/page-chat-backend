# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
require "faker"
require_relative "languages_seed"


# Country data with ISO3 codes and phone codes
COUNTRIES_DATA = [
  { name: "Afghanistan", code: "AF", iso3: "AFG", phone_code: "+93" },
  { name: "Albania", code: "AL", iso3: "ALB", phone_code: "+355" },
  { name: "Algeria", code: "DZ", iso3: "DZA", phone_code: "+213" },
  { name: "American Samoa", code: "AS", iso3: "ASM", phone_code: "+1-684" },
  { name: "Andorra", code: "AD", iso3: "AND", phone_code: "+376" },
  { name: "Angola", code: "AO", iso3: "AGO", phone_code: "+244" },
  { name: "Anguilla", code: "AI", iso3: "AIA", phone_code: "+1-264" },
  { name: "Antarctica", code: "AQ", iso3: "ATA", phone_code: "+672" },
  { name: "Antigua and Barbuda", code: "AG", iso3: "ATG", phone_code: "+1-268" },
  { name: "Argentina", code: "AR", iso3: "ARG", phone_code: "+54" },
  { name: "Armenia", code: "AM", iso3: "ARM", phone_code: "+374" },
  { name: "Aruba", code: "AW", iso3: "ABW", phone_code: "+297" },
  { name: "Asia/Pacific Region", code: "AP", iso3: nil, phone_code: nil },
  { name: "Australia", code: "AU", iso3: "AUS", phone_code: "+61" },
  { name: "Austria", code: "AT", iso3: "AUT", phone_code: "+43" },
  { name: "Azerbaijan", code: "AZ", iso3: "AZE", phone_code: "+994" },
  { name: "Bahamas", code: "BS", iso3: "BHS", phone_code: "+1-242" },
  { name: "Bahrain", code: "BH", iso3: "BHR", phone_code: "+973" },
  { name: "Bangladesh", code: "BD", iso3: "BGD", phone_code: "+880" },
  { name: "Barbados", code: "BB", iso3: "BRB", phone_code: "+1-246" },
  { name: "Belarus", code: "BY", iso3: "BLR", phone_code: "+375" },
  { name: "Belgium", code: "BE", iso3: "BEL", phone_code: "+32" },
  { name: "Belize", code: "BZ", iso3: "BLZ", phone_code: "+501" },
  { name: "Benin", code: "BJ", iso3: "BEN", phone_code: "+229" },
  { name: "Bermuda", code: "BM", iso3: "BMU", phone_code: "+1-441" },
  { name: "Bhutan", code: "BT", iso3: "BTN", phone_code: "+975" },
  { name: "Bolivia", code: "BO", iso3: "BOL", phone_code: "+591" },
  { name: "Bonaire, Sint Eustatius and Saba", code: "BQ", iso3: "BES", phone_code: "+599" },
  { name: "Bosnia and Herzegovina", code: "BA", iso3: "BIH", phone_code: "+387" },
  { name: "Botswana", code: "BW", iso3: "BWA", phone_code: "+267" },
  { name: "Bouvet Island", code: "BV", iso3: "BVT", phone_code: nil },
  { name: "Brazil", code: "BR", iso3: "BRA", phone_code: "+55" },
  { name: "British Indian Ocean Territory", code: "IO", iso3: "IOT", phone_code: "+246" },
  { name: "Brunei Darussalam", code: "BN", iso3: "BRN", phone_code: "+673" },
  { name: "Bulgaria", code: "BG", iso3: "BGR", phone_code: "+359" },
  { name: "Burkina Faso", code: "BF", iso3: "BFA", phone_code: "+226" },
  { name: "Burundi", code: "BI", iso3: "BDI", phone_code: "+257" },
  { name: "Cambodia", code: "KH", iso3: "KHM", phone_code: "+855" },
  { name: "Cameroon", code: "CM", iso3: "CMR", phone_code: "+237" },
  { name: "Canada", code: "CA", iso3: "CAN", phone_code: "+1" },
  { name: "Cape Verde", code: "CV", iso3: "CPV", phone_code: "+238" },
  { name: "Cayman Islands", code: "KY", iso3: "CYM", phone_code: "+1-345" },
  { name: "Central African Republic", code: "CF", iso3: "CAF", phone_code: "+236" },
  { name: "Chad", code: "TD", iso3: "TCD", phone_code: "+235" },
  { name: "Chile", code: "CL", iso3: "CHL", phone_code: "+56" },
  { name: "China", code: "CN", iso3: "CHN", phone_code: "+86" },
  { name: "Christmas Island", code: "CX", iso3: "CXR", phone_code: "+61" },
  { name: "Cocos (Keeling) Islands", code: "CC", iso3: "CCK", phone_code: "+61" },
  { name: "Colombia", code: "CO", iso3: "COL", phone_code: "+57" },
  { name: "Comoros", code: "KM", iso3: "COM", phone_code: "+269" },
  { name: "Congo", code: "CG", iso3: "COG", phone_code: "+242" },
  { name: "Congo, The Democratic Republic of the", code: "CD", iso3: "COD", phone_code: "+243" },
  { name: "Cook Islands", code: "CK", iso3: "COK", phone_code: "+682" },
  { name: "Costa Rica", code: "CR", iso3: "CRI", phone_code: "+506" },
  { name: "Croatia", code: "HR", iso3: "HRV", phone_code: "+385" },
  { name: "Cuba", code: "CU", iso3: "CUB", phone_code: "+53" },
  { name: "Curaçao", code: "CW", iso3: "CUW", phone_code: "+599" },
  { name: "Cyprus", code: "CY", iso3: "CYP", phone_code: "+357" },
  { name: "Czech Republic", code: "CZ", iso3: "CZE", phone_code: "+420" },
  { name: "Côte d'Ivoire", code: "CI", iso3: "CIV", phone_code: "+225" },
  { name: "Denmark", code: "DK", iso3: "DNK", phone_code: "+45" },
  { name: "Djibouti", code: "DJ", iso3: "DJI", phone_code: "+253" },
  { name: "Dominica", code: "DM", iso3: "DMA", phone_code: "+1-767" },
  { name: "Dominican Republic", code: "DO", iso3: "DOM", phone_code: "+1-809" },
  { name: "Ecuador", code: "EC", iso3: "ECU", phone_code: "+593" },
  { name: "Egypt", code: "EG", iso3: "EGY", phone_code: "+20" },
  { name: "El Salvador", code: "SV", iso3: "SLV", phone_code: "+503" },
  { name: "Equatorial Guinea", code: "GQ", iso3: "GNQ", phone_code: "+240" },
  { name: "Eritrea", code: "ER", iso3: "ERI", phone_code: "+291" },
  { name: "Estonia", code: "EE", iso3: "EST", phone_code: "+372" },
  { name: "Ethiopia", code: "ET", iso3: "ETH", phone_code: "+251" },
  { name: "Falkland Islands (Malvinas)", code: "FK", iso3: "FLK", phone_code: "+500" },
  { name: "Faroe Islands", code: "FO", iso3: "FRO", phone_code: "+298" },
  { name: "Fiji", code: "FJ", iso3: "FJI", phone_code: "+679" },
  { name: "Finland", code: "FI", iso3: "FIN", phone_code: "+358" },
  { name: "France", code: "FR", iso3: "FRA", phone_code: "+33" },
  { name: "French Guiana", code: "GF", iso3: "GUF", phone_code: "+594" },
  { name: "French Polynesia", code: "PF", iso3: "PYF", phone_code: "+689" },
  { name: "French Southern Territories", code: "TF", iso3: "ATF", phone_code: nil },
  { name: "Gabon", code: "GA", iso3: "GAB", phone_code: "+241" },
  { name: "Gambia", code: "GM", iso3: "GMB", phone_code: "+220" },
  { name: "Georgia", code: "GE", iso3: "GEO", phone_code: "+995" },
  { name: "Germany", code: "DE", iso3: "DEU", phone_code: "+49" },
  { name: "Ghana", code: "GH", iso3: "GHA", phone_code: "+233" },
  { name: "Gibraltar", code: "GI", iso3: "GIB", phone_code: "+350" },
  { name: "Greece", code: "GR", iso3: "GRC", phone_code: "+30" },
  { name: "Greenland", code: "GL", iso3: "GRL", phone_code: "+299" },
  { name: "Grenada", code: "GD", iso3: "GRD", phone_code: "+1-473" },
  { name: "Guadeloupe", code: "GP", iso3: "GLP", phone_code: "+590" },
  { name: "Guam", code: "GU", iso3: "GUM", phone_code: "+1-671" },
  { name: "Guatemala", code: "GT", iso3: "GTM", phone_code: "+502" },
  { name: "Guernsey", code: "GG", iso3: "GGY", phone_code: "+44" },
  { name: "Guinea", code: "GN", iso3: "GIN", phone_code: "+224" },
  { name: "Guinea-Bissau", code: "GW", iso3: "GNB", phone_code: "+245" },
  { name: "Guyana", code: "GY", iso3: "GUY", phone_code: "+592" },
  { name: "Haiti", code: "HT", iso3: "HTI", phone_code: "+509" },
  { name: "Heard Island and Mcdonald Islands", code: "HM", iso3: "HMD", phone_code: nil },
  { name: "Holy See (Vatican City State)", code: "VA", iso3: "VAT", phone_code: "+39" },
  { name: "Honduras", code: "HN", iso3: "HND", phone_code: "+504" },
  { name: "Hong Kong", code: "HK", iso3: "HKG", phone_code: "+852" },
  { name: "Hungary", code: "HU", iso3: "HUN", phone_code: "+36" },
  { name: "Iceland", code: "IS", iso3: "ISL", phone_code: "+354" },
  { name: "India", code: "IN", iso3: "IND", phone_code: "+91" },
  { name: "Indonesia", code: "ID", iso3: "IDN", phone_code: "+62" },
  { name: "Iran, Islamic Republic Of", code: "IR", iso3: "IRN", phone_code: "+98" },
  { name: "Iraq", code: "IQ", iso3: "IRQ", phone_code: "+964" },
  { name: "Ireland", code: "IE", iso3: "IRL", phone_code: "+353" },
  { name: "Isle of Man", code: "IM", iso3: "IMN", phone_code: "+44" },
  { name: "Israel", code: "IL", iso3: "ISR", phone_code: "+972" },
  { name: "Italy", code: "IT", iso3: "ITA", phone_code: "+39" },
  { name: "Jamaica", code: "JM", iso3: "JAM", phone_code: "+1-876" },
  { name: "Japan", code: "JP", iso3: "JPN", phone_code: "+81" },
  { name: "Jersey", code: "JE", iso3: "JEY", phone_code: "+44" },
  { name: "Jordan", code: "JO", iso3: "JOR", phone_code: "+962" },
  { name: "Kazakhstan", code: "KZ", iso3: "KAZ", phone_code: "+7" },
  { name: "Kenya", code: "KE", iso3: "KEN", phone_code: "+254" },
  { name: "Kiribati", code: "KI", iso3: "KIR", phone_code: "+686" },
  { name: "Korea, Republic of", code: "KR", iso3: "KOR", phone_code: "+82" },
  { name: "Kuwait", code: "KW", iso3: "KWT", phone_code: "+965" },
  { name: "Kyrgyzstan", code: "KG", iso3: "KGZ", phone_code: "+996" },
  { name: "Laos", code: "LA", iso3: "LAO", phone_code: "+856" },
  { name: "Latvia", code: "LV", iso3: "LVA", phone_code: "+371" },
  { name: "Lebanon", code: "LB", iso3: "LBN", phone_code: "+961" },
  { name: "Lesotho", code: "LS", iso3: "LSO", phone_code: "+266" },
  { name: "Liberia", code: "LR", iso3: "LBR", phone_code: "+231" },
  { name: "Libyan Arab Jamahiriya", code: "LY", iso3: "LBY", phone_code: "+218" },
  { name: "Liechtenstein", code: "LI", iso3: "LIE", phone_code: "+423" },
  { name: "Lithuania", code: "LT", iso3: "LTU", phone_code: "+370" },
  { name: "Luxembourg", code: "LU", iso3: "LUX", phone_code: "+352" },
  { name: "Macao", code: "MO", iso3: "MAC", phone_code: "+853" },
  { name: "Madagascar", code: "MG", iso3: "MDG", phone_code: "+261" },
  { name: "Malawi", code: "MW", iso3: "MWI", phone_code: "+265" },
  { name: "Malaysia", code: "MY", iso3: "MYS", phone_code: "+60" },
  { name: "Maldives", code: "MV", iso3: "MDV", phone_code: "+960" },
  { name: "Mali", code: "ML", iso3: "MLI", phone_code: "+223" },
  { name: "Malta", code: "MT", iso3: "MLT", phone_code: "+356" },
  { name: "Marshall Islands", code: "MH", iso3: "MHL", phone_code: "+692" },
  { name: "Martinique", code: "MQ", iso3: "MTQ", phone_code: "+596" },
  { name: "Mauritania", code: "MR", iso3: "MRT", phone_code: "+222" },
  { name: "Mauritius", code: "MU", iso3: "MUS", phone_code: "+230" },
  { name: "Mayotte", code: "YT", iso3: "MYT", phone_code: "+262" },
  { name: "Mexico", code: "MX", iso3: "MEX", phone_code: "+52" },
  { name: "Micronesia, Federated States of", code: "FM", iso3: "FSM", phone_code: "+691" },
  { name: "Moldova, Republic of", code: "MD", iso3: "MDA", phone_code: "+373" },
  { name: "Monaco", code: "MC", iso3: "MCO", phone_code: "+377" },
  { name: "Mongolia", code: "MN", iso3: "MNG", phone_code: "+976" },
  { name: "Montenegro", code: "ME", iso3: "MNE", phone_code: "+382" },
  { name: "Montserrat", code: "MS", iso3: "MSR", phone_code: "+1-664" },
  { name: "Morocco", code: "MA", iso3: "MAR", phone_code: "+212" },
  { name: "Mozambique", code: "MZ", iso3: "MOZ", phone_code: "+258" },
  { name: "Myanmar", code: "MM", iso3: "MMR", phone_code: "+95" },
  { name: "Namibia", code: "NA", iso3: "NAM", phone_code: "+264" },
  { name: "Nauru", code: "NR", iso3: "NRU", phone_code: "+674" },
  { name: "Nepal", code: "NP", iso3: "NPL", phone_code: "+977" },
  { name: "Netherlands", code: "NL", iso3: "NLD", phone_code: "+31" },
  { name: "Netherlands Antilles", code: "AN", iso3: "ANT", phone_code: "+599" },
  { name: "New Caledonia", code: "NC", iso3: "NCL", phone_code: "+687" },
  { name: "New Zealand", code: "NZ", iso3: "NZL", phone_code: "+64" },
  { name: "Nicaragua", code: "NI", iso3: "NIC", phone_code: "+505" },
  { name: "Niger", code: "NE", iso3: "NER", phone_code: "+227" },
  { name: "Nigeria", code: "NG", iso3: "NGA", phone_code: "+234" },
  { name: "Niue", code: "NU", iso3: "NIU", phone_code: "+683" },
  { name: "Norfolk Island", code: "NF", iso3: "NFK", phone_code: "+672" },
  { name: "North Korea", code: "KP", iso3: "PRK", phone_code: "+850" },
  { name: "North Macedonia", code: "MK", iso3: "MKD", phone_code: "+389" },
  { name: "Northern Mariana Islands", code: "MP", iso3: "MNP", phone_code: "+1-670" },
  { name: "Norway", code: "NO", iso3: "NOR", phone_code: "+47" },
  { name: "Oman", code: "OM", iso3: "OMN", phone_code: "+968" },
  { name: "Pakistan", code: "PK", iso3: "PAK", phone_code: "+92" },
  { name: "Palau", code: "PW", iso3: "PLW", phone_code: "+680" },
  { name: "Palestinian Territory, Occupied", code: "PS", iso3: "PSE", phone_code: "+970" },
  { name: "Panama", code: "PA", iso3: "PAN", phone_code: "+507" },
  { name: "Papua New Guinea", code: "PG", iso3: "PNG", phone_code: "+675" },
  { name: "Paraguay", code: "PY", iso3: "PRY", phone_code: "+595" },
  { name: "Peru", code: "PE", iso3: "PER", phone_code: "+51" },
  { name: "Philippines", code: "PH", iso3: "PHL", phone_code: "+63" },
  { name: "Pitcairn Islands", code: "PN", iso3: "PCN", phone_code: "+64" },
  { name: "Poland", code: "PL", iso3: "POL", phone_code: "+48" },
  { name: "Portugal", code: "PT", iso3: "PRT", phone_code: "+351" },
  { name: "Puerto Rico", code: "PR", iso3: "PRI", phone_code: "+1-787" },
  { name: "Qatar", code: "QA", iso3: "QAT", phone_code: "+974" },
  { name: "Reunion", code: "RE", iso3: "REU", phone_code: "+262" },
  { name: "Romania", code: "RO", iso3: "ROU", phone_code: "+40" },
  { name: "Russian Federation", code: "RU", iso3: "RUS", phone_code: "+7" },
  { name: "Rwanda", code: "RW", iso3: "RWA", phone_code: "+250" },
  { name: "Saint Barthélemy", code: "BL", iso3: "BLM", phone_code: "+590" },
  { name: "Saint Helena", code: "SH", iso3: "SHN", phone_code: "+290" },
  { name: "Saint Kitts and Nevis", code: "KN", iso3: "KNA", phone_code: "+1-869" },
  { name: "Saint Lucia", code: "LC", iso3: "LCA", phone_code: "+1-758" },
  { name: "Saint Martin", code: "MF", iso3: "MAF", phone_code: "+590" },
  { name: "Saint Pierre and Miquelon", code: "PM", iso3: "SPM", phone_code: "+508" },
  { name: "Saint Vincent and the Grenadines", code: "VC", iso3: "VCT", phone_code: "+1-784" },
  { name: "Samoa", code: "WS", iso3: "WSM", phone_code: "+685" },
  { name: "San Marino", code: "SM", iso3: "SMR", phone_code: "+378" },
  { name: "Sao Tome and Principe", code: "ST", iso3: "STP", phone_code: "+239" },
  { name: "Saudi Arabia", code: "SA", iso3: "SAU", phone_code: "+966" },
  { name: "Senegal", code: "SN", iso3: "SEN", phone_code: "+221" },
  { name: "Serbia", code: "RS", iso3: "SRB", phone_code: "+381" },
  { name: "Serbia and Montenegro", code: "CS", iso3: "SCG", phone_code: "+381" },
  { name: "Seychelles", code: "SC", iso3: "SYC", phone_code: "+248" },
  { name: "Sierra Leone", code: "SL", iso3: "SLE", phone_code: "+232" },
  { name: "Singapore", code: "SG", iso3: "SGP", phone_code: "+65" },
  { name: "Sint Maarten", code: "SX", iso3: "SXM", phone_code: "+1-721" },
  { name: "Slovakia", code: "SK", iso3: "SVK", phone_code: "+421" },
  { name: "Slovenia", code: "SI", iso3: "SVN", phone_code: "+386" },
  { name: "Solomon Islands", code: "SB", iso3: "SLB", phone_code: "+677" },
  { name: "Somalia", code: "SO", iso3: "SOM", phone_code: "+252" },
  { name: "South Africa", code: "ZA", iso3: "ZAF", phone_code: "+27" },
  { name: "South Georgia and the South Sandwich Islands", code: "GS", iso3: "SGS", phone_code: "+500" },
  { name: "South Sudan", code: "SS", iso3: "SSD", phone_code: "+211" },
  { name: "Spain", code: "ES", iso3: "ESP", phone_code: "+34" },
  { name: "Sri Lanka", code: "LK", iso3: "LKA", phone_code: "+94" },
  { name: "Sudan", code: "SD", iso3: "SDN", phone_code: "+249" },
  { name: "Suriname", code: "SR", iso3: "SUR", phone_code: "+597" },
  { name: "Svalbard and Jan Mayen", code: "SJ", iso3: "SJM", phone_code: "+47" },
  { name: "Swaziland", code: "SZ", iso3: "SWZ", phone_code: "+268" },
  { name: "Sweden", code: "SE", iso3: "SWE", phone_code: "+46" },
  { name: "Switzerland", code: "CH", iso3: "CHE", phone_code: "+41" },
  { name: "Syrian Arab Republic", code: "SY", iso3: "SYR", phone_code: "+963" },
  { name: "Taiwan", code: "TW", iso3: "TWN", phone_code: "+886" },
  { name: "Tajikistan", code: "TJ", iso3: "TJK", phone_code: "+992" },
  { name: "Tanzania, United Republic of", code: "TZ", iso3: "TZA", phone_code: "+255" },
  { name: "Thailand", code: "TH", iso3: "THA", phone_code: "+66" },
  { name: "Timor-Leste", code: "TL", iso3: "TLS", phone_code: "+670" },
  { name: "Togo", code: "TG", iso3: "TGO", phone_code: "+228" },
  { name: "Tokelau", code: "TK", iso3: "TKL", phone_code: "+690" },
  { name: "Tonga", code: "TO", iso3: "TON", phone_code: "+676" },
  { name: "Trinidad and Tobago", code: "TT", iso3: "TTO", phone_code: "+1-868" },
  { name: "Tunisia", code: "TN", iso3: "TUN", phone_code: "+216" },
  { name: "Turkey", code: "TR", iso3: "TUR", phone_code: "+90" },
  { name: "Turkmenistan", code: "TM", iso3: "TKM", phone_code: "+993" },
  { name: "Turks and Caicos Islands", code: "TC", iso3: "TCA", phone_code: "+1-649" },
  { name: "Tuvalu", code: "TV", iso3: "TUV", phone_code: "+688" },
  { name: "Uganda", code: "UG", iso3: "UGA", phone_code: "+256" },
  { name: "Ukraine", code: "UA", iso3: "UKR", phone_code: "+380" },
  { name: "United Arab Emirates", code: "AE", iso3: "ARE", phone_code: "+971" },
  { name: "United Kingdom", code: "GB", iso3: "GBR", phone_code: "+44" },
  { name: "United States", code: "US", iso3: "USA", phone_code: "+1" },
  { name: "United States Minor Outlying Islands", code: "UM", iso3: "UMI", phone_code: "+1" },
  { name: "Uruguay", code: "UY", iso3: "URY", phone_code: "+598" },
  { name: "Uzbekistan", code: "UZ", iso3: "UZB", phone_code: "+998" },
  { name: "Vanuatu", code: "VU", iso3: "VUT", phone_code: "+678" },
  { name: "Venezuela", code: "VE", iso3: "VEN", phone_code: "+58" },
  { name: "Vietnam", code: "VN", iso3: "VNM", phone_code: "+84" },
  { name: "Virgin Islands, British", code: "VG", iso3: "VGB", phone_code: "+1-284" },
  { name: "Virgin Islands, U.S.", code: "VI", iso3: "VIR", phone_code: "+1-340" },
  { name: "Wallis and Futuna", code: "WF", iso3: "WLF", phone_code: "+681" },
  { name: "Western Sahara", code: "EH", iso3: "ESH", phone_code: "+212" },
  { name: "Yemen", code: "YE", iso3: "YEM", phone_code: "+967" },
  { name: "Zambia", code: "ZM", iso3: "ZMB", phone_code: "+260" },
  { name: "Zimbabwe", code: "ZW", iso3: "ZWE", phone_code: "+263" },
  { name: "Åland Islands", code: "AX", iso3: "ALA", phone_code: "+358" }
].freeze

puts "Seeding countries..."

COUNTRIES_DATA.each do |country_data|
  Country.find_or_create_by!(code: country_data[:code]) do |country|
    country.name = country_data[:name]
    country.iso3 = country_data[:iso3]
    country.phone_code = country_data[:phone_code]
  end
end

puts "Seeded #{Country.count} countries."

puts "Seeding cities from JSON..."
puts "Reading cities data from local file..."

begin
  require "json"

  cities_file_path = Rails.root.join("db", "cities500.json")
  
  unless File.exist?(cities_file_path)
    puts "Cities file not found at #{cities_file_path}"
    puts "Skipping cities import."
  else
    puts "Reading cities from #{cities_file_path}..."
    cities_data = JSON.parse(File.read(cities_file_path))
    puts "Loaded #{cities_data.length} cities. Starting import..."
    
    # Create a hash of country codes for validation
    country_codes = Country.pluck(:code).to_set
    
    imported_count = 0
    skipped_count = 0
    error_count = 0
    
    cities_data.each_with_index do |city_json, index|
      country_code = city_json["country"]
      
      unless country_codes.include?(country_code)
        skipped_count += 1
        next
      end
      
      # Use a combination of name and country_code to avoid duplicates
      city = City.find_or_initialize_by(
        name: city_json["name"],
        country_code: country_code
      )
      
      # Update attributes if it's a new record or if we want to update existing
      city.state_province = city_json["admin1"] if city_json["admin1"].present?
      city.latitude = city_json["lat"].to_f if city_json["lat"].present?
      city.longitude = city_json["lon"].to_f if city_json["lon"].present?
      city.population = city_json["pop"].to_i if city_json["pop"].present?
      
      if city.save
        imported_count += 1
      else
        error_count += 1
        puts "Error saving city #{city_json["name"]}: #{city.errors.full_messages.join(", ")}" if city.errors.any?
      end
      
      # Progress indicator every 1000 cities
      if (index + 1) % 1000 == 0
        puts "Processed #{index + 1}/#{cities_data.length} cities... (imported: #{imported_count}, skipped: #{skipped_count}, errors: #{error_count})"
      end
    end
    
    puts "Cities import completed!"
    puts "  - Imported: #{imported_count}"
    puts "  - Skipped (no matching country): #{skipped_count}"
    puts "  - Errors: #{error_count}"
    puts "Total cities in database: #{City.count}"
  end
rescue StandardError => e
  puts "Error reading/importing cities: #{e.class} - #{e.message}"
  puts "Skipping cities import. You can run this manually later."
end

puts "Seeding book categories..."

CATEGORIES_DATA = [
  { name: "Fiction", description: "Imaginative works of prose, including novels and short stories" },
  { name: "Mystery", description: "Stories involving crime, detective work, and suspenseful investigations" },
  { name: "Thriller", description: "Fast-paced stories with high stakes, tension, and excitement" },
  { name: "Romance", description: "Stories focused on romantic relationships and love" },
  { name: "Science Fiction", description: "Speculative fiction exploring futuristic concepts and technology" },
  { name: "Fantasy", description: "Stories featuring magic, mythical creatures, and imaginary worlds" },
  { name: "Horror", description: "Stories designed to frighten, scare, or unsettle readers" },
  { name: "Historical Fiction", description: "Fictional stories set in the past with historical accuracy" },
  { name: "Literary Fiction", description: "Character-driven stories focusing on literary merit and style" },
  { name: "Young Adult", description: "Books written for readers aged 12-18, covering various genres" },
  { name: "Children's Books", description: "Books written for children, including picture books and early readers" },
  { name: "Biography", description: "Accounts of a person's life written by another person" },
  { name: "Autobiography", description: "Accounts of a person's life written by themselves" },
  { name: "Memoir", description: "Personal accounts of specific periods or events in someone's life" },
  { name: "Self-Help", description: "Books offering advice and strategies for personal improvement" },
  { name: "Business", description: "Books about business strategies, entrepreneurship, and management" },
  { name: "Economics", description: "Books about economic theory, markets, and financial systems" },
  { name: "History", description: "Non-fiction accounts of past events and historical periods" },
  { name: "Politics", description: "Books about political systems, ideologies, and current affairs" },
  { name: "Philosophy", description: "Books exploring fundamental questions about existence and knowledge" },
  { name: "Religion", description: "Books about religious beliefs, practices, and spirituality" },
  { name: "Spirituality", description: "Books about personal spiritual growth and enlightenment" },
  { name: "Psychology", description: "Books about human behavior, mental processes, and the mind" },
  { name: "Health & Fitness", description: "Books about physical health, exercise, and wellness" },
  { name: "Nutrition", description: "Books about diet, food science, and healthy eating" },
  { name: "Cookbooks", description: "Collections of recipes and cooking instructions" },
  { name: "Travel", description: "Books about travel destinations, guides, and experiences" },
  { name: "Adventure", description: "Stories featuring exciting journeys and daring exploits" },
  { name: "Action", description: "Fast-paced stories with physical conflict and excitement" },
  { name: "Crime", description: "Stories involving criminal activities and law enforcement" },
  { name: "Detective", description: "Stories featuring detectives solving crimes and mysteries" },
  { name: "Suspense", description: "Stories that create anxiety and uncertainty in readers" },
  { name: "Drama", description: "Serious stories with realistic characters and situations" },
  { name: "Comedy", description: "Humorous stories designed to entertain and amuse" },
  { name: "Satire", description: "Works using humor, irony, and exaggeration to criticize society" },
  { name: "Poetry", description: "Literary works written in verse form" },
  { name: "Short Stories", description: "Brief works of fiction, typically under 20,000 words" },
  { name: "Essays", description: "Short pieces of writing on a particular subject" },
  { name: "Classics", description: "Enduring works of literature recognized for their quality" },
  { name: "Contemporary Fiction", description: "Modern fiction set in the present day" },
  { name: "Women's Fiction", description: "Fiction focusing on women's experiences and relationships" },
  { name: "Chick Lit", description: "Light-hearted fiction primarily targeting young women" },
  { name: "LGBTQ+ Fiction", description: "Fiction featuring LGBTQ+ characters and themes" },
  { name: "Dystopian", description: "Stories set in oppressive, futuristic societies" },
  { name: "Utopian", description: "Stories depicting ideal or perfect societies" },
  { name: "Steampunk", description: "Science fiction set in a steam-powered Victorian era" },
  { name: "Cyberpunk", description: "Science fiction featuring advanced technology and dystopian futures" },
  { name: "Urban Fantasy", description: "Fantasy stories set in contemporary urban settings" },
  { name: "Paranormal", description: "Stories featuring supernatural elements and phenomena" },
  { name: "Vampire", description: "Stories featuring vampires and supernatural creatures" },
  { name: "Zombie", description: "Stories featuring zombies and post-apocalyptic scenarios" },
  { name: "Supernatural", description: "Stories involving forces beyond scientific understanding" },
  { name: "Western", description: "Stories set in the American Old West" },
  { name: "War", description: "Stories about military conflicts and warfare" },
  { name: "Military", description: "Stories about military life, strategy, and operations" },
  { name: "Espionage", description: "Stories about spies, intelligence, and secret operations" },
  { name: "Legal Thriller", description: "Thrillers set in the legal system and courtrooms" },
  { name: "Medical Thriller", description: "Thrillers involving medical settings and healthcare" },
  { name: "Political Thriller", description: "Thrillers involving political intrigue and power" },
  { name: "Psychological Thriller", description: "Thrillers focusing on mental and emotional tension" },
  { name: "True Crime", description: "Non-fiction accounts of real crimes and criminal cases" },
  { name: "Journalism", description: "Books about news reporting, media, and investigative journalism" },
  { name: "Education", description: "Books about teaching, learning, and educational systems" },
  { name: "Science", description: "Books about scientific discoveries, theories, and research" },
  { name: "Mathematics", description: "Books about mathematical concepts, theories, and applications" },
  { name: "Physics", description: "Books about physical laws, theories, and phenomena" },
  { name: "Chemistry", description: "Books about chemical processes, compounds, and reactions" },
  { name: "Biology", description: "Books about living organisms and life processes" },
  { name: "Astronomy", description: "Books about space, stars, planets, and the universe" },
  { name: "Technology", description: "Books about technological innovations and digital trends" },
  { name: "Computer Science", description: "Books about programming, algorithms, and computing" },
  { name: "Artificial Intelligence", description: "Books about AI, machine learning, and automation" },
  { name: "Environment", description: "Books about environmental issues, climate, and sustainability" },
  { name: "Nature", description: "Books about the natural world, wildlife, and ecosystems" },
  { name: "Animals", description: "Books about animals, pets, and wildlife" },
  { name: "Art", description: "Books about visual arts, painting, sculpture, and artistic movements" },
  { name: "Photography", description: "Books about photography techniques, history, and portfolios" },
  { name: "Music", description: "Books about music theory, history, musicians, and genres" },
  { name: "Film & TV", description: "Books about movies, television, and entertainment industry" },
  { name: "Theater", description: "Books about plays, acting, and theatrical productions" },
  { name: "Sports", description: "Books about sports, athletes, and athletic achievements" },
  { name: "Games", description: "Books about board games, video games, and gaming culture" },
  { name: "Hobbies", description: "Books about various hobbies and leisure activities" },
  { name: "Crafts", description: "Books about crafting, DIY projects, and handmade items" },
  { name: "Gardening", description: "Books about plants, gardening techniques, and landscaping" },
  { name: "Home & Garden", description: "Books about home improvement, interior design, and gardening" },
  { name: "Parenting", description: "Books about raising children and family relationships" },
  { name: "Relationships", description: "Books about romantic, family, and interpersonal relationships" },
  { name: "Dating", description: "Books about dating, courtship, and finding romantic partners" },
  { name: "Marriage", description: "Books about marriage, partnership, and long-term relationships" },
  { name: "Motivational", description: "Books designed to inspire and motivate readers" },
  { name: "Success", description: "Books about achieving success in various aspects of life" },
  { name: "Leadership", description: "Books about leadership skills, management, and influence" },
  { name: "Productivity", description: "Books about time management, efficiency, and getting things done" },
  { name: "Mindfulness", description: "Books about meditation, awareness, and present-moment living" },
  { name: "Meditation", description: "Books about meditation practices, techniques, and benefits" },
  { name: "Yoga", description: "Books about yoga practice, philosophy, and physical wellness" },
  { name: "Fashion", description: "Books about clothing, style, and fashion trends" },
  { name: "Beauty", description: "Books about beauty tips, skincare, and cosmetics" },
  { name: "Fashion & Style", description: "Books about personal style, fashion design, and trends" },
  { name: "Reference", description: "Books providing factual information and quick reference" },
  { name: "Dictionaries", description: "Reference books providing word definitions and meanings" },
  { name: "Encyclopedias", description: "Comprehensive reference works covering various topics" },
  { name: "Comics & Graphic Novels", description: "Visual storytelling through sequential art and illustrations" },
  { name: "Manga", description: "Japanese comic books and graphic novels" },
  { name: "Graphic Novels", description: "Book-length works in comic book format" },
  { name: "Humor", description: "Books designed to be funny and entertaining" },
  { name: "Inspirational", description: "Books meant to inspire and uplift readers" },
  { name: "Christian Fiction", description: "Fiction with Christian themes and values" },
  { name: "Christian Non-Fiction", description: "Non-fiction books about Christian faith and practice" },
  { name: "Bible Study", description: "Books for studying and understanding the Bible" },
  { name: "New Age", description: "Books about alternative spirituality and metaphysical topics" },
  { name: "Occult", description: "Books about supernatural, mystical, and esoteric subjects" }
].freeze

CATEGORIES_DATA.each do |category_data|
  Category.find_or_create_by!(name: category_data[:name]) do |category|
    category.description = category_data[:description]
  end
end

puts "Seeded #{Category.count} book categories."

puts "Seeding default users..."

# Get a random country and city for seed users
random_country = Country.order("RANDOM()").first
random_city = random_country ? City.where(country_code: random_country.code).order("RANDOM()").first : nil

if random_country.nil? || random_city.nil?
  puts "Warning: No countries or cities found. Skipping user seeding."
  puts "Please run countries and cities seeding first."
else
  10.times do |index|
    email = "seed_user_#{index + 1}@example.com"

    # Get random country and city for each user
    country = Country.order("RANDOM()").first
    city = City.where(country_code: country.code).order("RANDOM()").first if country

    next unless country && city

    User.find_or_create_by!(email: email) do |user|
      user.first_name = Faker::Name.first_name
      user.last_name = Faker::Name.last_name
      user.phone = "555-000-#{format('%04d', index)}"
      user.address = Faker::Address.street_address
      user.country_code = country.code
      user.city_id = city.id
      user.gender = %w[female male non_binary unspecified].sample
      user.date_of_birth = Faker::Date.birthday(min_age: 21, max_age: 65)
      user.password = "Password123!"
      user.password_confirmation = "Password123!"
    end
  end

  puts "Seeded #{User.where("email LIKE ?", "seed_user_%@example.com").count} users."
end
