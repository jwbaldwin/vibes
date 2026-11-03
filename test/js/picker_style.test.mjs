import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
const source = await readFile(new URL('../../assets/js/hooks/picker_style.js', import.meta.url), 'utf8');
const { default: hook, savedPickerStyle } = await import('data:text/javascript;base64,' + Buffer.from(source).toString('base64'));

const memoryStorage = (entries = {}) => {
  const values = new Map(Object.entries(entries));
  return { getItem: key => values.get(key) ?? null, setItem: (key, value) => values.set(key, value) };
};

test('unknown or missing saved styles fall back to on air', () => {
  assert.equal(savedPickerStyle(memoryStorage()), 'onair');
  assert.equal(savedPickerStyle(memoryStorage({ picker_style: 'sparkles' })), 'onair');
  assert.equal(savedPickerStyle(memoryStorage({ picker_style: 'vibes' })), 'vibes');
});

test('clicking switches styles, remembers the choice, and keeps the picker open', () => {
  globalThis.localStorage = memoryStorage();
  globalThis.document = { documentElement: { dataset: {} } };
  let onClick;
  const el = { textContent: '', addEventListener: (_event, callback) => { onClick = callback; }, removeEventListener() {} };
  const instance = { ...hook, el };
  instance.mounted();
  assert.equal(document.documentElement.dataset.pickerStyle, 'onair');

  let stopped = false;
  onClick({ stopPropagation: () => { stopped = true; } });
  assert.ok(stopped);
  assert.equal(document.documentElement.dataset.pickerStyle, 'vibes');
  assert.equal(localStorage.getItem('picker_style'), 'vibes');
  assert.equal(el.textContent, '[tiles: extra vibes]');

  delete globalThis.localStorage;
  delete globalThis.document;
});
