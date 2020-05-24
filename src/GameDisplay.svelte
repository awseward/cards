<script>
  export let selectedGame;
  async function fetchGameDetails(id) {
    const res = await fetch(`/api/game/${selectedGame.id}`);
    const text = await res.text();
    // TODO: Don't forget to remove this
    // await new Promise(resolve => setTimeout(resolve, 500));

    if (res.ok) {
      return text;
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
    <p><strong>Game details:</strong> {details}</p>
  {:catch error}
    <p style="color: red">{error.message}</p>
  {/await}
{/if}
