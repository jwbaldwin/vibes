export const PICKER_STYLES = { onair: 'tiles: on air', vibes: 'tiles: extra vibes' };

export const savedPickerStyle = (storage) =>
  storage.getItem('picker_style') in PICKER_STYLES ? storage.getItem('picker_style') : 'onair';

const PickerStyle = {
  mounted() {
    this.apply(savedPickerStyle(localStorage));
    // The picker overlay closes on any click, so keep this one from reaching it.
    this.onClick = (event) => {
      event.stopPropagation();
      const next = this.style === 'onair' ? 'vibes' : 'onair';
      localStorage.setItem('picker_style', next);
      this.apply(next);
    };
    this.el.addEventListener('click', this.onClick);
  },

  apply(style) {
    this.style = style;
    document.documentElement.dataset.pickerStyle = style;
    this.el.textContent = `[${PICKER_STYLES[style]}]`;
  },

  destroyed() {
    this.el.removeEventListener('click', this.onClick);
  },
};

export default PickerStyle;
