const TIP_SECONDS = 9;

const formatClock = (seconds) => {
  const pad = (n) => String(n).padStart(2, '0');
  const days = Math.floor(seconds / 86400);
  const clock = `${pad(Math.floor((seconds % 86400) / 3600))}h ${pad(Math.floor((seconds % 3600) / 60))}m ${pad(seconds % 60)}s`;
  return days > 0 ? `${days}d ${clock}` : clock;
};

const ForeverCountdown = {
  mounted() {
    this.launchAt = Date.parse(this.el.dataset.launchAt);
    this.tips = JSON.parse(this.el.dataset.tips);
    this.tipIndex = 0;
    this.secondsOnTip = 0;
    this.clock = this.el.querySelector('[data-clock]');
    this.tip = this.el.querySelector('[data-tip]');
    this.onTipClick = () => this.nextTip();
    this.tip.addEventListener('click', this.onTipClick);

    this.tick();
    this.ticker = setInterval(() => this.tick(), 1000);
  },

  tick() {
    const secondsLeft = Math.max(0, Math.floor((this.launchAt - Date.now()) / 1000));
    this.clock.textContent = formatClock(secondsLeft);
    this.el.dataset.state = secondsLeft === 0 ? 'live' : 'counting';
    this.el.classList.toggle('forever-final-minute', secondsLeft > 0 && secondsLeft <= 60);

    this.secondsOnTip += 1;
    if (this.secondsOnTip >= TIP_SECONDS) this.nextTip();
  },

  nextTip() {
    this.secondsOnTip = 0;
    this.tipIndex = (this.tipIndex + 1) % this.tips.length;
    this.tip.textContent = `tip: ${this.tips[this.tipIndex]}`;
    this.tip.classList.remove('forever-tip-in');
    // Force a reflow so the fade-in replays on every tip.
    void this.tip.offsetWidth;
    this.tip.classList.add('forever-tip-in');
  },

  destroyed() {
    clearInterval(this.ticker);
    this.tip.removeEventListener('click', this.onTipClick);
  },
};

export default ForeverCountdown;
