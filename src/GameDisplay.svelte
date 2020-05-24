<script>
  export let selectedGame;
  async function fetchGameDetails(id) {
    const res = await fetch(`/api/game/${selectedGame.id}`, {
      headers: { 'User-Id': window.userId }
    });
    const text = await res.text();
    // TODO: Don't forget to remove this
    // await new Promise(resolve => setTimeout(resolve, 500));

    if (res.ok) {
      return JSON.stringify(JSON.parse(text), null, 2);
    } else {
      throw new Error(text);
    }
  }
</script>

{#if selectedGame}
  <p><strong>Selected game:</strong> {selectedGame.id}</p>
  {#await fetchGameDetails(selectedGame.id)}
    <p>... fetching game details ...</p>
  {:then details}
    <div class="game-details"><strong>Game details:</strong> <pre>{details}</pre></div>
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
</style>
