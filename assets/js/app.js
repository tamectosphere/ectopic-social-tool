// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let Hooks = {}

Hooks.DateTimePickerToggle = {
  mounted() {

    let checkBox = document.querySelector('input[id="published_content_is_scheduled_post"]');
    let dateTimePicker = this.el;

    this.toggleDateTimePicker(checkBox, dateTimePicker);

    checkBox.addEventListener("change", () => {
      this.toggleDateTimePicker(checkBox, dateTimePicker);
    });
  },

  toggleDateTimePicker(checkBox, dateTimePicker) {

    if (checkBox.checked) {
        // this.pushEvent("toggle_scheduled_post", {is_scheduled_post: true})
        dateTimePicker.style.display = "block";
    } else {
        // this.pushEvent("toggle_scheduled_post", {is_scheduled_post: false})
        dateTimePicker.style.display = "none";
    }
  },
};

Hooks.SelectSocialAccount = {
  mounted() {
    this.el.addEventListener("click", e => {
      // Remove the class from the previously selected element
      let previous = this.el.closest("ul").querySelector(".social-account-selected");
      if (previous) {
        previous.classList.remove("social-account-selected");
      }

      // Add the class to the current element
      this.el.classList.add("social-account-selected");
    });
  }
};


Hooks.OnToastOpen = {
    mounted() {
        const toasts = document.querySelectorAll(".toast");
        
        toasts.forEach(toast => {

            const id = toast.id
            const flashKey = id.split('-')[1]

            setTimeout(() => {
                if (toast) {
                    clearToast(this, toast, flashKey)
                }
            }, 2000); 
        });
    }
}


Hooks.OnToastClose = {
    mounted() {
        this.el.addEventListener("click", e => {
            const id = e.target.parentElement.parentElement.parentElement.id
            const flashKey = id.split('-')[1]
            const toast = document.querySelector(`#${id}`);
            
            if (toast) {
                clearToast(this, toast, flashKey)
            }
        });
    }
}

function clearToast(context, toast, flashKey){
    toast.classList.remove("flashhits");
    toast.classList.add("flashhide");

    toast.addEventListener('animationend', () => {
        if (flashKey) {
            context.pushEvent("lv:clear-flash", {key: flashKey})
        }
    });

}


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken},  hooks: Hooks})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

