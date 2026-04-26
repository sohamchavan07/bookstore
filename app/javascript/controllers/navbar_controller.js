import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.handleScroll = this.handleScroll.bind(this)
    window.addEventListener("scroll", this.handleScroll)
    this.handleScroll()
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll)
  }

  handleScroll() {
    if (window.scrollY > 50) {
      this.element.classList.remove("bg-transparent", "border-transparent")
      this.element.classList.add("bg-slate-900/85", "backdrop-blur-lg", "border-slate-800", "shadow-lg", "shadow-indigo-500/10")
      // Shrink padding
      const container = this.element.querySelector('.container')
      if (container) {
         container.style.height = '60px';
         container.style.transition = 'height 0.3s ease';
      }
    } else {
      this.element.classList.add("bg-transparent", "border-transparent")
      this.element.classList.remove("bg-slate-900/85", "backdrop-blur-lg", "border-slate-800", "shadow-lg", "shadow-indigo-500/10")
      // Restore padding
      const container = this.element.querySelector('.container')
      if (container) {
         container.style.height = '80px';
      }
    }
  }
}
