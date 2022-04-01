import { useState } from 'react';

const Showcase = (props) => {
  const nameLengthThreshold = 8;
  const [isVisible, setIsVisible] = useState(true);

  const handleClickVisibilityToggleButton = () => {
    setIsVisible(!isVisible)
  }

  return (
    <>
      { /*中括弧の中でprops、及びあらゆるJSの式を使うことが出来る*/ }
      <p>Hi, I'm {props.name}</p>
      <p>
        The answer is {props.answer}, so the doubled answer is {''}
        {props.answer * 2}.
      </p>

      {/* 論理式を使って表示を切り替えたり出来る */}
      {isVisible && <p>This is Visible</p>}
      <button onClick={handleClickVisibilityToggleButton}>
        Toggle visibility
      </button>

      {props.name.length >= nameLengthThreshold ? (
        <p>name.length is equal or longer than {nameLengthThreshold}.</p>
      ) : (
        <p>name.length is less than {nameLengthThreshold}.</p>
      )}

      <ul>
        {props.items.map((item) => {
          <li key={item.id}>
            {item.name} is {item.price} Yen.
          </li>
        })}
      </ul>
    </>
  );
}

const App = () => {
  const name = 'Nasu Panda';
  const answer = 20;
  const items = [
    {
      id: 1,
      name: "T-shirt",
      price: 100,
    },
    {
      id: 2,
      name: "Hoodie",
      price: 300,
    },
  ]
  return(
    <Showcase
      name={name}
      answer={answer}
      items={items}
    ></Showcase>
  )
};

export default App;