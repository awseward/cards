<script>
  let games = [];
  export let selectedGame = null;

  async function fetchGames() {
    const res = await fetch("/api/games");
    const text = await res.text();

    if (res.ok) {
      return JSON.parse(text);
    } else {
      throw new Error(text);
    }
  }

  async function createNewGame() {
    const res = await fetch("/api/games", {
      method: 'POST'
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

<button on:click={createNewGame}>Create a new game</button>
