import React from 'react';
import { createRoot } from 'react-dom/client';
import QuillEditor from "./components/QuillEditor";

const container = document.getElementById('root');
const root = createRoot(container);

document.addEventListener('DOMContentLoaded', () => {
  root.render(<QuillEditor default_value={content} />);
});
