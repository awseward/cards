<script>
  let games = [];
  export let selectedGame = null;

  let allGames = [];
  let selectedToJoin = null;

  async function fetchGames() {
    const res = await fetch("/api/games", {
      headers: { 'User-Id': window.userId }
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
      headers: { 'User-Id': window.userId }
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

<h3>Your Games</h3>
<p>These are games you're a participant in</p>

<select bind:value={selectedGame}>
  <option disabled selected value> -- select a game -- </option>
  {#each games as game}
    <option value={game}>
      Game {game.id}
    </option>
  {/each}
</select>

<h4>All other games</h4>

<select bind:value={selectedToJoin}>
  <option disabled selected value> -- select a game -- </option>
  {#each allGames as game}
    <option value={game}>
      Game {game.id}
    </option>
  {/each}
</select>

</div>
  <button on:click={createNewGame}>Create a new game</button>
</div>
