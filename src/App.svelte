<script>
  import SomeComponent from './SomeComponent.svelte';
  export let name;
  let promise;

  async function getSomeData() {
    const res = await fetch("/api/");
    const text = await res.text();

    if (res.ok) {
      return text;
    } else {
      throw new Error(text);
    }
  }

  function handleClick() {
    promise = getSomeData();
  }
</script>

<main>
  <h1>Hello {name}!</h1>
  <p>Visit the <a href="https://svelte.dev/tutorial">Svelte tutorial</a> to learn how to build Svelte apps.</p>

  <input bind:value={name} placeholder="Your name here">

  <SomeComponent imgUrl="https://media.giphy.com/media/3EiNpweH34XGoQcq9Q/giphy.gif" />

  {#await promise}
    <p>...waiting</p>
  {:then text}
    <p>{text}</p>
  {:catch error}
    <p style="color: red">{error.message}</p>
  {/await}

  <button on:click={handleClick}>
    Fetch some data
  </button>
</main>

<style>
  main {
    text-align: center;
    padding: 1em;
    max-width: 240px;
    margin: 0 auto;
  }

  h1 {
    color: #ff3e00;
    text-transform: uppercase;
    font-size: 4em;
    font-weight: 100;
  }

  @media (min-width: 640px) {
    main {
      max-width: none;
    }
  }
</style>
