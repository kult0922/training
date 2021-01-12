import '@testing-library/jest-dom/extend-expect';
import { render, fireEvent, waitFor } from '@testing-library/svelte';
import TaskNew from 'pages/TaskNew';

test('shows proper elements', async () => {
    const { queryByText, getByLabelText, getByRole } = render(TaskNew);
    ["タスク名", "説明文", "完了日を入力"].forEach( label => {
        expect(getByLabelText(label, { selector: 'input' })).toBeInTheDocument();
    })
    expect(getByLabelText("ステータス:", { selector: 'select' })).toBeInTheDocument();
    expect(getByRole("button", { name: '作成' })).toBeInTheDocument();
    expect(queryByText("完了日:")).not.toBeInTheDocument();
    await fireEvent.click(getByLabelText("完了日を入力"));
    await waitFor(() => {
        expect(getByLabelText("完了日:", { selector: 'input' })).toBeInTheDocument()
    });
})

const setup = () => {
    const utils = render(TaskNew)
    const inputName = utils.getByLabelText("タスク名")
    return {
        inputName,
        ...utils
    }
}
test('submit button should be disable until input name', async () => {
    const { inputName, getByRole, getByLabelText } = setup()
    expect(getByRole("button", { name: "作成" })).toBeDisabled();
    await fireEvent.change(inputName, { target: { value: 'Test' }});
    await waitFor(() => {
            expect(inputName.value).toBe('Test')
        }, { timeout: 1000 });
    // TODO: does not work.
    // await fireEvent.click(getByLabelText("説明文", { selector: 'input' }));
    // await waitFor(() => {
    //     expect(getByRole("button", { name: "作成" })).toBeEnabled()
    //     },
    //     { timeout: 1000 });
})
