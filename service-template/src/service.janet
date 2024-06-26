(import spork/httpf)
(import spork/htmlgen)
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
   [:link @{:rel "stylesheet" :type "text/css" :href "styles.css"}]
  [:body
   [:div body]]])

(defn styles-css {:path "/styles.css" :render-mime "text/css"} [&]
 (slurp "./public/styles.css"))

(defn home {:path "/"} [&]
 (base-html
  [:div
   [:h1 "Bonjour"]]))

(defn start-service []
 (-> (httpf/server)
     httpf/add-bindings-as-routes
     (httpf/listen dashboard/local-ip (dashboard/port-map :template))))

(start-service)
