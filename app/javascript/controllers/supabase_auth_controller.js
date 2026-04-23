import { Controller } from "@hotwired/stimulus"
import { createClient } from "@supabase/supabase-js"

export default class extends Controller {
  static targets = ["email", "otp", "message", "emailSection", "otpSection"]
  static values = {
    url: String,
    key: String
  }

  connect() {
    this.supabase = createClient(this.urlValue, this.keyValue)
  }

  async sendOtp(event) {
    event.preventDefault()
    const email = this.emailTarget.value

    if (!email) {
      this.messageTarget.textContent = "Please enter an email address."
      return
    }

    const { error } = await this.supabase.auth.signInWithOtp({
      email: email,
      options: {
        shouldCreateUser: true
      }
    })

    if (error) {
      this.messageTarget.textContent = error.message
    } else {
      this.messageTarget.textContent = "OTP sent to your email!"
      this.emailSectionTarget.classList.add("hidden")
      this.otpSectionTarget.classList.remove("hidden")
    }
  }

  async verifyOtp(event) {
    event.preventDefault()
    const email = this.emailTarget.value
    const token = this.otpTarget.value

    const { data: { session }, error } = await this.supabase.auth.verifyOtp({
      email,
      token,
      type: 'email'
    })

    if (error) {
      this.messageTarget.textContent = error.message
    } else {
      this.messageTarget.textContent = "Successfully verified! Logging you in..."
      this.signInOnRails(session.access_token)
    }
  }

  async signInOnRails(accessToken) {
    const response = await fetch("/auth/verify", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ access_token: accessToken })
    })

    if (response.ok) {
      window.location.href = "/"
    } else {
      this.messageTarget.textContent = "Failed to sign in on server."
    }
  }
}
