import React, { useState } from 'react';
import ReactQuill from 'react-quill';
import 'react-quill/dist/quill.snow.css';
import unescapeHtml from "../libs/unescapeHTML";

const QuillEditor = (props) => {
  const delta = unescapeHtml(props.default_value);
  const [value, setValue] = useState(props.default_value);
  console.log(value);

  return <ReactQuill theme="snow" defaultValue={delta} onChange={setValue} />;
}

export default QuillEditor;