<script>
  import { userId } from './stores.js';
  import ApiInfo from './ApiInfo.svelte';
  import GamePicker from './GamePicker.svelte';
  import GameDisplay from './GameDisplay.svelte';

  let selectedGame;
  let refreshGames;
</script>

<main>
  <p>Visit the <a href="https://svelte.dev/tutorial">Svelte tutorial</a> to learn how to build Svelte apps.</p>

  <ApiInfo/>
  <p><strong>Your User ID:</strong> {$userId}</p>

  <GamePicker bind:selectedGame bind:refreshGames />
  <GameDisplay bind:game={selectedGame} on:gameDeleted={refreshGames} />
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
