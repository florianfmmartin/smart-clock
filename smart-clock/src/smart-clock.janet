(import spork/httpf)
(import spork/htmlgen)
(import ./weather)
(import ../../home-dashboard/config :as :dashboard)

(defn base-html [body]
 [:html {:lang "en"}
  [:head
   [:title "title"]
   [:meta {:charset "utf-8"}]
   [:meta {:name "viewport" :content "width=device-width, initial-scale=1"}]]
   [:link {:rel "preconnect" :href "https://fonts.googleapis.com"}]
   [:link {:rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin true}]
   [:link {:href "https://fonts.googleapis.com/css2?family=Courier+Prime:ital,wght@0,400;0,700;1,400;1,700&display=swap" :rel "stylesheet"}]
   [:script (htmlgen/raw  "setTimeout(() => window.location.reload(), 1000 * 60 * 15)")]
   [:script (htmlgen/raw "const upTime = () => { console.log('Update time'); const el = document.getElementById('ze-time'); const date = new Date(); el.innerText = `${date.getHours()}:${String(date.getMinutes()).padStart(2, '0')}`; setTimeout(upTime, 5000); }; setTimeout(upTime, 5000);")]
   [:link @{:rel "stylesheet" :type "text/css" :href "styles.css"}]
  [:body
   [:div body]]])

(defn styles-css {:path "/styles.css" :render-mime "text/css"} [&]
 (slurp "./public/styles.css"))

(defn show-time []
 [:div @{:class "block time"}
  [:h2 @{:id "ze-time"} "Maintenant"]])

(defn home {:path "/"} [&]
 (base-html
  [:div
   [:h1 "Bonjour Florian & Catherine 😊"]
   [:div @{:class "block-container"}
    (show-time)
    ;(weather/show)]]))

(defn start []
 (-> (httpf/server)
     httpf/add-bindings-as-routes
     (httpf/listen dashboard/local-ip (dashboard/port-map :smart-clock))))

(start)
