(() => {
  if (window.__bookstoreGoogleAnalyticsInitialized) return;

  window.__bookstoreGoogleAnalyticsInitialized = true;
  window.dataLayer = window.dataLayer || [];
  window.gtag = window.gtag || function gtag() {
    window.dataLayer.push(arguments);
  };

  const script = document.createElement("script");
  script.async = true;
  script.src = "https://www.googletagmanager.com/gtag/js?id=G-Q936RT7FM1";
  document.head.appendChild(script);

  window.gtag("js", new Date());
  window.gtag("config", "G-Q936RT7FM1");
})();
