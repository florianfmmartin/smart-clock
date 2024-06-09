(import spork/http)
(import spork/json)
(import ./weather-icon)

(def weather-api
 "http://api.open-meteo.com/v1/forecast?latitude=46.837909266447575&longitude=-71.23182429135484&current=temperature_2m,apparent_temperature,precipitation,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,precipitation_probability_max&timezone=America%2FNew_York&forecast_days=1")

(defn get-weather []
 (json/decode
  (get (http/request "GET" weather-api) :body) true true))

(defn show-current
 [temp apparent-temp img precipitation]
 [:div @{:class "block"}
  [:h2 "Présentement"]
  [:div @{:class "main"}
   [:p (string apparent-temp "°")]
   [:img @{:src img}]]
  [:div @{:class "second"}
   [:p (string "réelle: " temp "°")]
   [:p (string "précipitations: " precipitation "mm")]]])

(defn show-today
 [t-max t-min img milli percent]
 [:div @{:class "block today"}
  [:h2 "Aujourd'hui"]
  [:div @{:class "main"}
   [:p (string t-max "°")]
   [:img @{:src img}]
   [:p (string t-min "°")]]
  [:div @{:class "second"}
   [:p (string "probabilité: " percent "%")]
   [:p (string "précipitations: " milli "mm")]]])

(defn show []
 (let [weather (get-weather)]
  [
  (show-current
   (math/round (get-in weather [:current :temperature_2m]))
   (math/round (get-in weather [:current :apparent_temperature]))
   (weather-icon/get-image-from-code (get-in weather [:current :weather_code]))
   (get-in weather [:current :precipitation]))
  (show-today
   (math/round (get-in weather [:daily :temperature_2m_max 0]))
   (math/round (get-in weather [:daily :temperature_2m_min 0]))
   (weather-icon/get-image-from-code (get-in weather [:daily :weather_code 0]))
   (get-in weather [:daily :precipitation_sum 0])
   (get-in weather [:daily :precipitation_probability_max 0]))]))

