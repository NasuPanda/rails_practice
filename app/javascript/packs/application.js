import Rails from "@rails/ujs"
import ReactDOM from "react-dom"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery"
import "bootstrap"
import App from "components"
import { resolve } from "core-js/fn/promise"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("DOMContentLoaded", () => {
  ReactDOM.render(<App />, document.getElementById("app"))
})

// turbolinksによる画面遷移時は DOMContentLoaded ではなく turbolinks:load イベントが発火する
document.addEventListener("turbolinks:load", () => {
  ReactDOM.render(<App />, document.getElementById("app"))
})

$("#micropost_image").bind("change", function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert("Maximum file size is 5MB. Please choose a smaller file.");
      $("#micropost_image").val("");
    }
  });