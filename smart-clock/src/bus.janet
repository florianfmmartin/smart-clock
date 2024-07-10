(import sh)
(import spork/json)

(def transit-api "http://external.transitapp.com/v3")

(def bus-stops {:28 "RTC:95249"})

(defn departures-url [bus-stop]
 (string transit-api "/public/stop_departures?global_stop_id=" bus-stop))

(defn get-departures [bus-stop]
 (let [transit-url (departures-url bus-stop)]
  (json/decode
   (sh/$< wget --quiet --method GET
    --header "apiKey: NULL"
    --output-document
    - ,transit-url)
   true true)))

(def departures-key [:route_departures 0 :itineraries 0 :schedule_items])
(defn get-28 []
 (get-in (get-departures (get bus-stops :28)) departures-key))

