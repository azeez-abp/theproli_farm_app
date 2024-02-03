import logo from './logo.svg';
import './App.css';
import {useEffect, useState} from 'react'

function App() {

  const [state,setState]   = useState(null);

  const getData = async() =>{
    // Data to send in the POST request
const data = {
  key1: 'value1',
  key2: 'value2'
  // Add more data here as needed
};

// Convert the data to URL-encoded format
//const formData = new URLSearchParams(data);

// URL to the API endpoint
const url = 'http://127.0.0.1:801/api/post';

try{
  let response= await fetch(url, {
    method: 'POST',
    body: JSON.stringify(data)
  })
 
  if (response.ok) {
    // Parse the response JSON data
    const responseData = await response.json();

    // Use responseData in your code as needed
    console.log(responseData);

    // Update your state with the responseData
    setState(responseData);
  } else {
    console.log('Request failed with status:', response.status);
  }
  
}catch(e){
  console.log(e)
}
// Fetch API using the POST method

 

  
  }

  useEffect(()=>{
    
   getData()

  },[])
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          FRONT END APP WELCOME  {state && state.ok} 
        </p>
       
      </header>
    </div>
  );
}

export default App;
