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

<details open class="info-outer" transition:fade="{{ duration: 200 }}">
  <summary>
    <strong>API Info</strong>
  </summary>
  <pre class="info-inner">{prettyJson(details)}</pre>
</details>

<style>
  .info-outer {
    width: 500px;
    margin-left: auto;
    margin-right: auto;
    padding: 5px;
    background-color: #CCC;
  }

  summary {
    padding: 10px 0px 10px 10px;
    text-align: left;
  }

  .info-inner {
    padding: 20px;
    margin: 0px;
    background-color: #EEE;
    text-align: left;
  }
</style>
