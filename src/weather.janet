(import spork/http)
(import spork/json)
(import ./weather-icon)

(def weather-api
 "http://api.open-meteo.com/v1/forecast?latitude=46.837909266447575&longitude=-71.23182429135484&current=temperature_2m,apparent_temperature,weather_code")

(defn get-weather []
 (json/decode
  (get (http/request "GET" weather-api) :body) true true))


(defn show-today [temp apparent-temp img]
 [:div @{:class "today"}
  [:div @{:class "main"}
   [:p (string apparent-temp "°")]
   [:img @{:src img}]]
  [:div @{:class "second"}
   [:p (string "actuelle " temp "°")]]])

(defn show []
 (let [weather (get-weather)]
  (show-today
   (math/round (get-in weather [:current :temperature_2m]))
   (math/round (get-in weather [:current :apparent_temperature]))
   (weather-icon/get-image-from-code (get-in weather [:current :weather_code])))))

