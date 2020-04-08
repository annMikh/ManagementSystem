//
//  DocumentSerializable.swift
//  ManagementSystem
//
//  Created by Анна Михалева on 04.04.2020.
//  Copyright © 2020 Анна Михалева. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

public protocol DocumentSerializable {

  /// Initializes an instance from a Firestore document. May fail if the
  /// document is missing required fields.
  init?(document: QueryDocumentSnapshot)

  /// Initializes an instance from a Firestore document. May fail if the
  /// document does not exist or is missing required fields.
  init?(document: DocumentSnapshot)

  /// The representation of a document-serializable object in Firestore.
  var documentData: [String: Any] { get }

}
