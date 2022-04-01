import { useState } from 'react';

const PetsTable = (props) => {
  const pets = props.pets;

  const createTable = (elements) => {
    const table = elements.map((element) =>
      <tr>
        <td>{element.name}</td>
        <td>{element.species}</td>
      </tr>
    );
    return table;
  }

  const initial_table = createTable(pets);
  const [table, setTable] = useState(initial_table);

  const handleClickAllAnimalVisibilityToggleButton = () => {
    const displayTable = createTable(pets);
    setTable(displayTable);
  }

  const handleClickCatVisibilityToggleButton = () => {
    const cats = pets.filter(pet => pet.species !== "dog");
    const displayCats = createTable(cats);
    setTable(displayCats);
  }

  const handleClickDogVisibilityToggleButton = () => {
    const dogs = pets.filter(pet => pet.species !== "cat");
    const displayDogs = createTable(dogs);
    setTable(displayDogs);
  }

  const handleSubmit = (e) => {
    const species = e.target[0].value;
    const name = e.target[1].value;
    if (!species || !name) {
      alert("Please input")
      return
    } else {
      pets.push({ name: name, species: species })
      setTable(createTable(pets))
    }
    e.preventDefault();
  }

  return (
    <>
    {table}
    <button onClick={handleClickAllAnimalVisibilityToggleButton}>
      All animal
    </button>
    <button onClick={handleClickCatVisibilityToggleButton}>
      Cat
    </button>
    <button onClick={handleClickDogVisibilityToggleButton}>
      Dog
    </button>
    {/* フォーム */}
    <form onSubmit={handleSubmit}>
      <label>
        Select Dog/Cat
        <select>
          <option value="dog">dog</option>
          <option value="cat">cat</option>
        </select>
      </label>
      <label>
        Put a name
        <input name="name" type="text" />
      </label>
      <input type="submit" value="Submit" />
    </form>
    </>
  );
}

const App = () => {
  const pets = [
    { name: "Pochi", species: "dog" },
    { name: "Tama", species: "cat" },
    { name: "Mike", species: "cat" },
    { name: "Hachi", species: "dog" },
  ];
  return(
    <PetsTable
      pets={pets}>
    </PetsTable>
    )
};

export default App;