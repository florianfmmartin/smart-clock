(import spork/http)
(import spork/httpf)
(import spork/htmlgen)
(import spork/json)

# https://gist.github.com/stellasphere/9490c195ed2b53c707087c8c2db4ec0c
(defn get-image-from-code [code]
 (string "https://openweathermap.org/img/wn/" code "d@2x.png"))

(def weather-api
 "http://api.open-meteo.com/v1/forecast?latitude=46.837909266447575&longitude=-71.23182429135484&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,sunrise,sunset,precipitation_sum&timezone=America%2FNew_York&forecast_days=3")

(defn get-weather []
 (let [weather (json/decode
                (get (http/request "GET" weather-api) :body))]
  (string "Il fait " (string (get-in weather ["current" "temperature_2m"])) " avec un ressenti de " (get-in weather ["current" "apparent_temperature"]))))

(defn base-html [body]
 [:html {:lang "en"}
  [:head
   [:title "title"]
   [:meta {:charset "utf-8"}]
   [:meta {:name "viewport" :content "width=device-width, initial-scale=1"}]]
   [:script (htmlgen/raw  "setTimeout(() => window.location.reload(), 1000 * 60 * 15)")]
  [:body
   [:div body]
   [:style (htmlgen/raw "h1 { color: red; }")]]])

(defn home {:path "/"} [&]
 (base-html
  [:div
   [:h1 "Bonjour Florian & Catherine 😊"]
   [:p (get-weather)]]))

(defn start []
 (-> (httpf/server)
     httpf/add-bindings-as-routes
     httpf/listen))

(start)
