import React, { useState } from 'react';
import ReactQuill from 'react-quill';
import 'react-quill/dist/quill.snow.css';
import unescapeHtml from "../libs/unescapeHTML";

const QuillEditor = (props) => {
  const delta = unescapeHtml(props.defaultValue);
  const [value, setValue] = useState(delta);

  return (
    <>
      <ReactQuill theme="snow" defaultValue={delta} onChange={setValue} />
      <input type={"hidden"} name={props.inputName} value={value} />
    </>
  );
}

export default QuillEditor;