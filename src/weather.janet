(import spork/http)
(import spork/json)
(import ./weather-icon)

(def weather-api
 "http://api.open-meteo.com/v1/forecast?latitude=46.837909266447575&longitude=-71.23182429135484&current=temperature_2m,apparent_temperature,precipitation,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,precipitation_probability_max&timezone=America%2FNew_York")

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

# TODO
(defn show-today
 [temp apparent-temp img precipitation]
 [:div @{:class "block"}
  [:div @{:class "main"}
   [:p (string apparent-temp "°")]
   [:img @{:src img}]]
  [:div @{:class "second"}
   [:p (string "réelle: " temp "°")]
   [:p (string "précipitations: " precipitation "mm")]]])

(defn show []
 (let [weather (get-weather)]
  (show-current
   (math/round (get-in weather [:current :temperature_2m]))
   (math/round (get-in weather [:current :apparent_temperature]))
   (weather-icon/get-image-from-code (get-in weather [:current :weather_code]))
   (get-in weather [:current :precipitation]))))

