<script>
  export let selectedGame;

  async function fetchGameDetails(id) {
    const res = await fetch(`/api/game/${selectedGame.id}`, {
      headers: { 'User-Id': window.userId }
    });
    const text = await res.text();

    if (res.ok) {
      return JSON.parse(text);
    } else {
      throw new Error(text);
    }
  }

  function prettyJson(obj) {
    return JSON.stringify(obj, null, 2);
  }

  function handleLeaveButtonClick() {
    alert("TODO: leave game");
  }
</script>

{#if selectedGame}
  <p><strong>Selected game:</strong> {selectedGame.id}</p>
  {#await fetchGameDetails(selectedGame.id)}
    <p>... fetching game details ...</p>
  {:then details}
    <div class="game-details">
      <strong>Game details:</strong> <pre>{prettyJson(details)}</pre>
    </div>
    {#if details.status === 'pending' || details.status === 'ready'}
      <button class="leave-game" on:click={handleLeaveButtonClick}>Leave Game</button>
    {/if}
  {:catch error}
    <p style="color: red">{error.message}</p>
  {/await}
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

  .leave-game {
    margin-top: 20px;
  }
</style>
