(import spork/httpf)
(import spork/htmlgen)
(import ./weather)
(import ../../home-dashboard/config :as :dashboard)
(import ./note)

(defn base-html [body]
 [:html {:lang "en"}
  [:head
   [:title "title"]
   [:meta {:charset "utf-8"}]
   [:meta {:name "viewport" :content "width=device-width, initial-scale=1"}]]
   [:link {:rel "preconnect" :href "https://fonts.googleapis.com"}]
   [:link {:rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin true}]
   [:link {:href "https://fonts.googleapis.com/css2?family=Courier+Prime:ital,wght@0,400;0,700;1,400;1,700&display=swap" :rel "stylesheet"}]
   [:script @{:src "https://unpkg.com/petite-vue" :defer true :init true}]
   [:script @{:type "module" :src "https://md-block.verou.me/md-block.js"}]
   [:script (htmlgen/raw  "setTimeout(() => window.location.reload(), 1000 * 60 * 15)")]
   [:script (htmlgen/raw "const upTime = () => { const el = document.getElementById('ze-time'); const date = new Date(); el.innerText = `${date.getHours()}:${String(date.getMinutes()).padStart(2, '0')}`; setTimeout(upTime, 1000); }; setTimeout(upTime, 5000);")]
   [:script (htmlgen/raw "const upWelcome = () => { const el = document.getElementById('ze-welcome'); const date = new Date(); if (date.getHours() >= 22 || date.getHours() < 7) { el.innerText = 'Bonne nuit Flo & Cat 😴' } else if (date.getHours() >= 17) { el.innerText = 'Bonsoir Flo & Cat 😊' } else { el.innerText = 'Bonjour Flo & Cat 😎'}; setTimeout(upWelcome, 1000); }; setTimeout(upWelcome, 1000 * 60 * 5);")]
   [:link @{:rel "stylesheet" :type "text/css" :href "styles.css"}]
  [:body
   [:div @{"v-scope" true} body]]])

(defn styles-css {:path "/styles.css" :render-mime "text/css"} [&]
 (slurp "./public/styles.css"))

(defn show-time []
 [:div @{:class "block time"}
  [:h2 @{:id "ze-time"} "Maintenant"]])

(defn home {:path "/"} [&]
 (base-html
  [:div
   [:h1 @{:id "ze-welcome"} "Bonjour Flo & Cat 😊"]
   [:div @{:class "block-container"}
    (show-time)
    ;(weather/show)
    (note/show)]]))

(defn get-note {:path "/note"} [&]
 (note/read-save-file))

(defn update-note {:path "/note/update"} [req data]
 (note/write-save-file data))

(defn start-service []
 (-> (httpf/server)
     httpf/add-bindings-as-routes
     (httpf/listen dashboard/local-ip (dashboard/port-map :smart-clock))))

(start-service)
