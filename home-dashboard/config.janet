(use sh)

(def services [:dashboard :smart-clock])

(def ip-addr-output ($< ip addr | grep 192.168))

(def local-ip
 (get
  (->> ip-addr-output
   (string/split " ")
   (find (fn [e] (string/has-prefix? "192" e)))
   (string/split "/"))
  0))

(var base-port 4200)
(defn use-port []
 (let [port base-port]
  (set base-port (+ 1 base-port))
  port))

(def port-map
 (struct
  ;(flatten
    (map (fn [k] [k (use-port)]) services))))

