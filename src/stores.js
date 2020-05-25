import { readable } from 'svelte/store';

function getUserId() {
  let found = document.cookie.split('; ').map(str => str.split('=')).filter(arr => arr[0] == 'user_id');
  return found
    ? found[0][1]
    : null
  ;
}

export const userId = readable(getUserId(), function start(_set) {});
