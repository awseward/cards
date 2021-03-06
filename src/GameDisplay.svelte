<script>
  import { createEventDispatcher } from 'svelte';
  import { fade } from 'svelte/transition';
  import { userId, defaultHeaders } from './stores.js';

  const dispatch = createEventDispatcher();

  export let game = null;
  let details;
  let detailsPromise;
  let loading;
  $: {
    if (game) {
      detailsPromise = fetchGameDetails(game.id);
    }
  }
  $: pendingOrReady = details && (details.status === 'pending' || details.status === 'ready')

  async function fetchGameDetails(gameId) {
    loading = true;
    try {
      const res = await fetch(`/api/game/${gameId}`, {
        headers: $defaultHeaders
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
      loading = false;
    }
  }

  async function joinGame(gameId) {
    const res = await fetch(`/api/game/${gameId}/join`, {
      headers: $defaultHeaders,
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
      headers: $defaultHeaders,
      method: 'PUT'
    });

    if (res.ok) {
      detailsPromise = fetchGameDetails(gameId);
      await detailsPromise;
      game = null;
    } else {
      throw new Error(await res.text());
    }
  }

  async function deleteGame(gameId) {
    loading = true;
    try {
      const res = await fetch(`/api/game/${gameId}`, {
        headers: $defaultHeaders,
        method: 'DELETE'
      });
      if (res.ok) {
        dispatch('gameDeleted', {});
        details = null;
        game = null;
      } else {
        throw new Error(await res.text());
      }
    } finally { loading = false; }
  }

  async function startGame(gameId) {
    alert('TODO: start game functionality');
  }

  function prettyJson(obj) {
    return JSON.stringify(obj, null, 2);
  }

  function isUserInGame(game) {
    return game.players.map(u => u.user_id).includes($userId);
  }
</script>

{#if game }
  <p><strong>Selected game:</strong> {game.id}</p>

  {#if details}
    <details open class="info-outer" class:loading in:fade="{{ duration: 200 }}" out:fade="{{ duration: 500 }}">
      <summary>
        <strong>Game {details.id}</strong>
      </summary>
      <pre class="info-inner">{prettyJson(details)}</pre>
    </details>




    {#if isUserInGame(details) }
      {#if pendingOrReady}
        <button class="game-action" on:click={() => leaveGame(details.id)}>Leave Game</button>
      {/if}
      {#if details.status === 'ready'}
        <button class="game-action" on:click={() => startGame(details.id)}>Start game</button>
      {/if}
    {:else}
      {#if pendingOrReady}
        <button class="game-action" on:click={() => joinGame(details.id)}>Join Game</button>
      {/if}
    {/if}
    {#if pendingOrReady}
      <button class="game-action" on:click={() => deleteGame(details.id)}>Delete Game</button>
    {/if}
  {/if}
{/if}

<style>
  .info-outer {
    width: 500px;
    margin-left: auto;
    margin-right: auto;
    padding: 5px;
    background-color: #CCC;
  }

  summary {
    padding: 10px 0px 10px 10px;
    text-align: left;
  }

  .info-inner {
    padding: 20px;
    margin: 0px;
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
