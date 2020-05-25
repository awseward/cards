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
      <button class="leave-or-join" on:click={() => leaveGame(details.id)}>Leave Game</button>
    {:else}
      <p>Cannot leave game unless it is status: pending or ready.
    {/if}
  {:else}
    {#if details.status === 'pending' || details.status === 'ready'}
      <button class="leave-or-join" on:click={() => joinGame(details.id)}>Join Game</button>
    {:else}
      <p>Cannot leave game unless it is status: pending or ready.
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

  .leave-or-join {
    margin-top: 20px;
  }
</style>
