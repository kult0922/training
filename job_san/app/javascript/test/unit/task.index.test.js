import '@testing-library/jest-dom/extend-expect';
import { render, waitFor } from '@testing-library/svelte';
import TaskList from 'pages/TaskList';
import axios from "axios";

jest.mock('axios');

afterEach(() => {
    jest.clearAllMocks();
});

test('shows proper elements', async () => {
    const tasks = [{
        "id":3,
        "name":"zaaaaaa",
        "description":"",
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
    const { queryByText } = render(TaskList);

    ["ID", "タスク名", "ステータス", "完了日", "作成日", "🗑"].forEach(i => {
        expect(queryByText(i)).toBeInTheDocument();
    })
    await waitFor(() => {
        expect(queryByText("zaaaaaa")).toBeInTheDocument();
    }, { timeout: 1000 });
})
