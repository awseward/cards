<script>
  import GamePicker from './GamePicker.svelte';
  import GameDisplay from './GameDisplay.svelte';

  let selectedGame;
  let userId = getUserId();
  window.userId = userId;

  function getUserId() {
    let found = document.cookie.split('; ').map(str => str.split('=')).filter(arr => arr[0] == 'user_id');
    return found
      ? found[0][1]
      : null
    ;
  }
</script>

<main>
  <p>Visit the <a href="https://svelte.dev/tutorial">Svelte tutorial</a> to learn how to build Svelte apps.</p>

  <p><strong>User ID:</strong> {userId}</p>

  <GamePicker bind:selectedGame />
  <GameDisplay bind:game={selectedGame} />
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
