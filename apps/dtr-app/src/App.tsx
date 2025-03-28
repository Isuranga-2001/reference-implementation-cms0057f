import './App.css'
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import SamplePage from "./pages/sample";
import LoginV2 from './pages/login_v2';
import { AuthProvider } from './components/AuthProvider';

// Extend the Window interface to include the Config property
declare global {
  interface Window {
    Config: {
      baseUrl: string;
      demoBaseUrl: string;
      medication_request: string;
      prescribe_medication: string;
      questionnaire_package: string;
      questionnaire_response: string;
      claim_submit: string;
      radiology_order: string;
      book_imaging_center: string;
      practitioner: string;
      practitioner_new: string;
      slot: string;
      location: string;
      appointment: string;
      patient: string;
    };
  }
}

function App() {
  return (
    <Router>
      <AuthProvider>
        <Routes>
          <Route path="/" element={<SamplePage />} />
          <Route path="/login" element={<LoginV2 />} />
        </Routes>
      </AuthProvider>
    </Router>
  )
}

export default App
