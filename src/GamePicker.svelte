<script>
  import { userId } from './stores.js';

  export let selectedGame = null;
  export let refreshGames = () => fetchGames().then(gs => games = gs);
  let games = [];
  let select;
  $: {
    if (selectedGame === null && select) {
      select.selectedIndex = 0;
    }
  }

  async function fetchGames() {
    const res = await fetch("/api/games", {
      headers: { 'User-Id': $userId }
    });
    const text = await res.text();

    if (res.ok) {
      return JSON.parse(text);
    } else {
      throw new Error(text);
    }
  }

  async function createNewGame() {
    const res = await fetch("/api/games", {
      method: 'POST',
      headers: { 'User-Id': $userId }
    });
    const text = await res.text();

    if (res.ok) {
      const game = JSON.parse(text);
      games = [...games, game];
      selectedGame = game;
    } else {
      throw new Error(text);
    }
  }

  refreshGames();
</script>

<div>
  <button on:click={createNewGame}>Create a new game</button>
</div>

<h3>Games</h3>

<select bind:value={selectedGame} bind:this={select}>
  <option disabled selected value>-- select a game --</option>
  {#each games as game (game.id)}
    <option value={game}>
      Game {game.id}
    </option>
  {/each}
</select>

