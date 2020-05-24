<script>
  export let games = [];
  let selectedGame;
  let gamesPromise = Promise.resolve([]);

  async function fetchGames() {
    const res = await fetch("/api/games");
    const text = await res.text();

    if (res.ok) {
      return JSON.parse(text);
    } else {
      throw new Error(text);
    }
  }

  fetchGames().then(gs => games = gs);
</script>

<h3>Games</h3>

<select bind:value={selectedGame}>
  <option disabled selected value> -- select a game -- </option>
  {#each games as game}
    <option value={game}>
      {game.id} {game.created_at}
    </option>
  {/each}
</select>

{#if selectedGame}
  <p>Selected: <strong>{selectedGame.id}</strong></p>
{/if}
