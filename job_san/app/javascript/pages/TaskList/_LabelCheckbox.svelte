<script>
  export let label = {};
  export let attachLabels = [];
  export let onClickLabelCheckbox = () => {};

  $: isChecked = attachLabels.filter((l) => l.id === label.id).length > 0;
</script>

<label>
  <input
    type="checkbox"
    checked={isChecked}
    on:click={() => onClickLabelCheckbox(label)} />
  {label.name}
</label>
