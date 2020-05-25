<script>
  export let selectedGame;
  $: detailsPromise = fetchGameDetails(selectedGame.id);

  async function fetchGameDetails(gameId) {
    const res = await fetch(`/api/game/${gameId}`, {
      headers: { 'User-Id': window.userId }
    });
    const text = await res.text();

    if (res.ok) {
      return JSON.parse(text);
    } else {
      throw new Error(text);
    }
  }

  async function joinGame(gameId) {
    const res = await fetch(`/api/game/${gameId}/join`, {
      headers: { 'User-Id': window.userId },
      method: 'PUT'
    });

    if (res.ok) {
      detailsPromise = fetchGameDetails(gameId);
    } else {
      throw new Error(await res.text());
    }
  }

  async function leaveGame(gameId) {
    const res = await fetch(`/api/game/${gameId}/leave`, {
      headers: { 'User-Id': window.userId },
      method: 'PUT'
    });

    if (res.ok) {
      detailsPromise = fetchGameDetails(gameId);
    } else {
      throw new Error(await res.text());
    }
  }

  async function startGame(gameId) {
    alert('TODO: start game functionality');
  }

  function prettyJson(obj) {
    return JSON.stringify(obj, null, 2);
  }

  function isUserInGame(game) {
    return game.players.map(u => u.user_id).includes(window.userId);
  }
</script>

<p><strong>Selected game:</strong> {selectedGame.id}</p>

{#await detailsPromise}
  <p>... fetching game details ...</p>
{:then details}
  <div class="game-details">
    <strong>Game details:</strong> <pre>{prettyJson(details)}</pre>
  </div>

  {#if isUserInGame(details) }
    {#if details.status === 'pending' || details.status === 'ready'}
      <button class="game-action" on:click={() => leaveGame(details.id)}>Leave Game</button>
    {/if}
    {#if details.status === 'ready'}
      <button class="game-action" on:click={() => startGame(details.id)}>Start game</button>
    {/if}
  {:else}
    {#if details.status === 'pending' || details.status === 'ready'}
      <button class="game-action" on:click={() => joinGame(details.id)}>Join Game</button>
    {/if}
  {/if}

{:catch error}
  <p style="color: red">{error.message}</p>
{/await}

<style>
  .game-details {
    width: 500px;
    margin-left: auto;
    margin-right: auto;
    padding: 20px;
    background-color: #EEE;
    text-align: left;
  }

  .game-action {
    margin-top: 20px;
  }
</style>
