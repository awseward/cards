<script>
  export let game = null;
  let details;
  let detailsPromise;
  let detailsLoading;
  $: {
    if (game) {
      detailsPromise = fetchGameDetails(game.id);
    }
  }

  async function fetchGameDetails(gameId) {
    detailsLoading = true;
    try {
      const res = await fetch(`/api/game/${gameId}`, {
        headers: { 'User-Id': window.userId }
      });
      const text = await res.text();
      await new Promise(resolve => setTimeout(resolve, 300));

      if (res.ok) {
        details = JSON.parse(text);
        return details;
      } else {
        throw new Error(text);
      }
    } finally {
      detailsLoading = false;
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
      await detailsPromise;
      await new Promise(resolve => setTimeout(resolve, 400));
      game = null;
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

{#if game }
  <p><strong>Selected game:</strong> {game.id}</p>

  {#if details}
    <div class="game-details" class:loading={detailsLoading}>
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
  {/if}
{/if}

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

  .loading {
    filter: blur(1.5px);
    opacity: 0.9;
    /* animation: anim-loading 0.2s 1 ease-in-out alternate-reverse; */
  }

  @keyframes anim-loading {
    from {
      transform: translateY(0) scale(1);
    }
    to {
      transform: translateY(-5px) scale(0.98);
    }
  }
</style>
