import '@testing-library/jest-dom/extend-expect';
import { render, waitFor } from '@testing-library/svelte';
import TaskList from 'pages/TaskList';
import axios from "axios";

jest.mock('axios');

afterEach(() => {
    jest.clearAllMocks();
});

test('when visit task list page', async () => {
    const tasks = [{
        "id":3,
        "name":"サンプルタスク名",
        "description":"サンプル説明文",
        "created_at":"2021-01-08T03:14:24.000+09:00",
        "updated_at":"2021-01-08T03:14:24.000+09:00",
        "priority":null,
        "status":"todo",
        "user_id":"c48d18ba-508d-11eb-9773-0242ac140002",
        "label_id":null,
        "target_date":null
    }]
    const response = {data: tasks};
    axios.get.mockResolvedValue(response);
    const { queryByText, getByRole, getByPlaceholderText, getByLabelText } = render(TaskList);

    expect(getByPlaceholderText("タスク名")).toBeInTheDocument();
    expect(getByRole("button", { name: "検索" } )).toBeInTheDocument();
    await waitFor(() => {
        expect(queryByText("サンプルタスク名")).toBeInTheDocument();
        expect(queryByText("未設定")).toBeInTheDocument();
        expect(queryByText("2021年01月08日")).toBeInTheDocument();
    }, { timeout: 1000 });
})
