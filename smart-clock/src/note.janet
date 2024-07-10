(def save-file "./public/note.txt")

(defn read-save-file []
 (slurp save-file))

(defn write-save-file [content]
 (spit save-file content))

(defn show []
 [:div @{:class "block note"}
  [:div @{:v-scope "{ note: null, edit: false }" :@vue:mounted "fetch('/note').then(data => data.text()).then(text => note = text)"}
   [:p @{:v-effect "$el.textContent = note" ::class "{ hidden: edit }"}]
   [:textarea @{:v-model "note" ::class "{ hidden: !edit }"}]
   [:div @{:class "buttons"}
    [:button @{:@click "edit ? (() => { edit = false; fetch('/note/update', {method: 'POST', body: note}) })() : fetch('/note').then(data => data.text()).then(text => note = text)"} "🔄"]
    [:button @{::class "{ hidden: edit }" :@click "edit = !edit"} "✏️"]]]])

