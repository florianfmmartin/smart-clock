(import spork/httpf)
(import spork/htmlgen)
(import ./weather)

(defn base-html [body]
 [:html {:lang "en"}
  [:head
   [:title "title"]
   [:meta {:charset "utf-8"}]
   [:meta {:name "viewport" :content "width=device-width, initial-scale=1"}]]
   [:script (htmlgen/raw  "setTimeout(() => window.location.reload(), 1000 * 60 * 15)")]
   [:link @{:rel "stylesheet" :type "text/css" :href "styles.css"}]
  [:body
   [:div body]]])

(defn styles-css {:path "/styles.css"} [&]
 (slurp "./public/styles.css"))

(defn home {:path "/"} [&]
 (base-html
  [:div
   [:h1 "Bonjour Florian & Catherine 😊"]
   [:div (weather/show)]]))

(defn start []
 (-> (httpf/server)
     httpf/add-bindings-as-routes
     httpf/listen))

(start)
