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