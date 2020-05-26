<script>
  import { fade } from 'svelte/transition';
  import { defaultHeaders } from './stores.js';

  let details;

  async function fetchDetails() {
    const res = await fetch(`/api/info`, {
      headers: $defaultHeaders
    });
    const text = await res.text();
    if (res.ok) {
      return JSON.parse(text);
    } else { throw new Error(text); }
  }

  function prettyJson(obj) {
    return JSON.stringify(obj, null, 2);
  }

  fetchDetails().then(x => details = x);
</script>

<div class="details" transition:fade="{{ duration: 200 }}">
  <strong>API Info:</strong> <pre>{prettyJson(details)}</pre>
</div>

<style>
  .details {
    width: 500px;
    margin-left: auto;
    margin-right: auto;
    padding: 20px;
    background-color: #EEE;
    text-align: left;
  }
</style>
